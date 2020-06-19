#!/usr/bin/python3
'''
LSTM for CME price data
'''

__author__ = "VW Freeh"

import argparse
import logging
import logging.handlers
import copy

import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score
import warnings

from utils import CustomScaler

# suppress warnings
with warnings.catch_warnings():
    warnings.filterwarnings("ignore", category=FutureWarning)
    import tensorflow as tf
    from tensorflow.keras.models import Sequential
    from tensorflow.keras.layers import Dense, LSTM

tf.get_logger().setLevel('ERROR')


def createScaledTimeSeries(args, raw, months, scaleColumns):
    scaled = {}
    for month in months:
        scaled[month] = {}
        years = pd.unique(raw[raw['month'] == month]['year'])

        data = pd.DataFrame()
        for year in years:
            ts = raw[(raw['year'] == year) & (raw['month'] == month)]
            if len(ts) > 0:
                ts = ts.copy()
                ts.sort_values(by=['date'], inplace=True)
                ts = ts.reset_index(drop=True)
                scaled[month][year] = ts
                data = data.append(ts[scaleColumns])

        # transform the data for the month
        data = np.array(data)
        scaler = StandardScaler()
        scaler.fit(data)

        scaled[month]['scaler'] = CustomScaler(scaler, len(scaleColumns))

    return scaled


def mkTrainingData(df, month, backoff, window, scaleCols, rawCols, target):
    X = pd.DataFrame()
    y = []
    end_day = backoff + window

    M = df[month]
    years = M.keys()

    scaler = M['scaler']
    for year in years:
        if isinstance(year, str):
            continue   # only process years; skip scaler
        ts = M[year]
        # grab window rows
        rows = ts[(ts['day'] >= backoff) & (ts['day'] < end_day)]
        if len(rows) == window:
            # reverse order
            rows = rows.iloc[::-1]
            tgtday = ts[ts['day'] == target].iloc[0]
            X = X.append(rows)
            # store y
            y.append(list(tgtday[scaleCols]) + list(tgtday[rawCols]))

    # scale left (scaleCols)
    X = scaler.transform(X)

    # scale and shape y values
    y = scaler.transform(y)

    return X, y


def createModel(args, shape):
    model = Sequential()
    model.add(LSTM(units=30,
                   return_sequences=True,
                   input_shape=shape))
    model.add(LSTM(units=30, return_sequences=True))
    model.add(LSTM(units=30))
    model.add(Dense(units=2))
    if args.verbose:
        model.summary()

    return model


def evaluate(args, scaler, X_test, y_test, y_predict):
    inverter = scaler.inverse_transform
    I = lambda x: inverter(x)[0]

    results = []
    for i in range(len(X_test)):
        X_0 = I(X_test[i][0])
        true = I(y_test[i])
        pred = I(y_predict[i])
        results.append((X_0, true, pred))

    return results


def run(args):
    scaleColumns = ['close', ]
    rawColumns = ['day', ]

    # read data
    crop = args.crop.lower()
    try:
        raw = pd.read_csv(f'{crop}.csv')
        raw = raw.append(pd.read_csv(f'{crop}_barchart_new.csv'))
    except FileNotFoundError as e:
        raise ValueError(e)

    args.logger.debug('read %d rows', len(raw))

    if args.verbose:
        print(raw.columns)

    if crop == 'corn':
        # purge bad data
        raw = raw[raw['month'] != 10]

    months = list(pd.unique(raw['month']))

    if args.month:
        new_months = []
        for m in args.month:
            if m in months:
                new_months.append(m)
            else:
                args.logger.error('invalid month %d ignored', m)
        if len(new_months) == 0:
            raise ValueError('no months')
        months = new_months

    scaled = createScaledTimeSeries(args, raw, months, scaleColumns)

    header = 'C   T  W  M   B     x_0    true    pred  diff%    gain  gain%'
    fmt = '{:1s} {:3d} {:2d} {:2d} {:3d} {:7.2f} {:7.2f} {:7.2f} {:+6.2f} '\
          '{:+7.2f} {:6.1f}'

    for window in args.window:
        for month in months:
            modelBase = createModel(
                args, (window, len(scaleColumns) + len(rawColumns)))
            for backoff in args.backoff:
                model = copy.copy(modelBase)

                X, y = mkTrainingData(scaled, month, backoff, window,
                                      scaleColumns, rawColumns, args.target)
                try:
                    X_train, X_test, y_train, y_test = \
                        train_test_split(X, y, test_size=.1)
                except ValueError as e:
                    args.logger.debug("%d %d %d %d %s",
                                      crop, window, month, backoff, e)
                    continue

                model.compile(optimizer='adam', loss='mean_squared_error')
                model.fit(X_train, y_train, epochs=args.epochs,
                          batch_size=args.batch, verbose=0)

                y_predict = model.predict(X_test)
                results = evaluate(args, scaled[month]['scaler'],
                                   X_test, y_test, y_predict)

                args.logger.info(header)
                t = []
                p = []
                for x0, true, predict in results:
                    t.append(true)
                    p.append(predict)
                    diff = (predict - true)/true * 100
                    gain = true - x0
                    if gain:
                        gainpred = (predict-x0)/gain * 100
                    else:
                        gainpred = predict - x0
                    msg = fmt.format(
                        crop[0].upper(), args.target, window, month, backoff,
                        x0, true, predict, diff, gain, gainpred)
                    args.logger.info(msg)
                mse = mean_squared_error(t, p)
                r2 = r2_score(t, p)
                args.logger.info(
                    '{:1s} {:3d} {:2d} {:2d} {:3d} mse={:.2f} r2={:.4f}'.
                    format(
                        crop[0].upper(), args.target, window, month, backoff,
                        mse, r2))


def main():
    '''
    create and run LSTM models
    '''
    parser = argparse.ArgumentParser(description=main.__doc__)
    parser.add_argument('-d', '--debug', action="count",
                        help='set debug level')
    parser.add_argument('-v', '--verbose', action="count",
                        help='set verbose level')
    parser.add_argument('-l', '--logfile', type=str, default='-',
                        help='set log file (default stderr "-")')
    parser.add_argument('-w', '--window', type=int, nargs="+",
                        default=[30],
                        help='specify windows. default=[30]')
    parser.add_argument('-b', '--backoff', type=int, nargs="+",
                        default=[180],
                        help='specify backoffs. default=[180]')
    parser.add_argument('-m', '--month', type=int, nargs="+",
                        default=None,
                        help='specify months. default=all')
    parser.add_argument('--batch', type=int, default=25,
                        help='set batch size of model.fit. default=25.')
    parser.add_argument('--epochs', type=int, default=200,
                        help='set number of epochs for model.fit. '
                        'default=200.')
    parser.add_argument('-t', '--target', type=int, default=0,
                        help='set target date. default=0.')
    parser.add_argument('-c', '--crop', type=str, default='corn',
                        help='crop: corn, soybeans, wheat')
    # parser.add_argument('file', type=argparse.FileType('r'),
    #                     help='input filename (required)')

    args = parser.parse_args()

    crop = args.crop.lower()
    if crop not in ['corn', 'soybeans', 'wheat']:
        print('invalid crop')
        exit(-1)

    logger = logging.getLogger()
    if args.logfile == '-':
        # send to stderr
        hdlr = logging.StreamHandler()
        formatter = logging.Formatter('%(levelname)s %(message)s')
    else:
        hdlr = logging.handlers.RotatingFileHandler(args.logfile,
                                                    maxBytes=2**24,  # 4MB
                                                    backupCount=5)
        formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')

    if args.debug:
        logger.setLevel(logging.DEBUG)
    else:
        logger.setLevel(logging.INFO)
    hdlr.setFormatter(formatter)
    logger.addHandler(hdlr)

    setattr(args, 'logger', logger)

    if args.debug:
        print('PARAMETERS')
        for k, v in args.__dict__.items():
            print("\t{:>10s} - {}".format(k, v))
        print()

    run(args)


if __name__ == "__main__":
    main()
