#!/usr/bin/python
'''
Create Crop DataFrame
'''

__author__ = "VW Freeh"

import sys
import os
import glob
import argparse
import logging
import logging.handlers
import pandas as pd


# convert a string to datetime field
def convertToDateOld(date):
    # format is YYMMDD
    date_str = '{:06d}'.format(date)
    if int(date_str[0]) < 3:
        date_str = '20' + date_str   # make it 20yy instead of just yy
    else:
        date_str = '19' + date_str   # make it 19yy instead of just yy
    format = "%Y%m%d"
    datetime = pd.to_datetime(date_str, format=format)
    return datetime


def convertToDateNew(date_str):
    # format is MM/DD/YYYY
    format = "%m/%d/%Y"
    datetime = pd.to_datetime(date_str, format=format)
    return datetime


# reads and transforms raw csv data
# raw file has date, open, close, volume, and openint
# compute day as the number of days before end of contract
# add {open, close} x {net, rel} columns,
# which the prices minus/divide final (net/rel)
# reverse order so that contract data is first
# add column that is the year of the contract
def process_file(file_name, encoding):
    if encoding == 'old':
        df = pd.read_csv(file_name, header=None, usecols=[0, 1, 4, 5, 6])
        df[0] = df[0].apply(convertToDateOld)
        df = df.rename(columns={
            1: "open", 4: "close", 5: "volume", 6: "openint", 0: 'date'})
    else:
        df = pd.read_csv(file_name, usecols=[0, 1, 4, 5, 6])
        df['Date'] = df['Date'].apply(convertToDateNew)
        df = df.rename(columns={
            'Open': "open", 'Close': "close", 'Date': 'date',
            'Volume': "volume", 'OpenInt': "openint"})

    enddate = df['date'].iloc[-1]
    compute_days = lambda x: (enddate - x).days
    df['day'] = df["date"].apply(compute_days)
    # df_copy = df.copy()

    days_max = df["day"].iloc[0]
    final_close = df['close'].iloc[-1]

    # insert "missing days"
    df2 = pd.DataFrame(columns=['open', 'close', 'open_net', 'close_net',
                                'open_rel', 'close_rel', 'volume',
                                'openint', 'day'])
    last = days_max + 1
    for i in range(len(df)):
        row = df.iloc[i]
        row = row.copy()
        day = df.iloc[i]['day']
        row['open_net'] = row['open'] - final_close
        row['close_net'] = row['close'] - final_close
        row['open_rel'] = row['open'] / final_close
        row['close_rel'] = row['close'] / final_close
        # insert this row and "missing days", eg, weekends and holidays
        for k in range(last - day):
            row = row.copy()
            row['day'] = last - 1 - k
            df2 = df2.append(row)
        last = day

    # reverse order (last is first)
    df2 = df2[::-1]
    df2 = df2.reset_index(drop=True)
    df2.insert(loc=0, column='month', value=enddate.month)
    df2.insert(loc=0, column='year', value=enddate.year)
    return df2


def run(args):
    args.logger.debug(str(args))
    columns = [
        'year', 'month', 'open', 'close', 'open_net', 'close_net', 'open_rel',
        'close_rel', 'volume', 'openint', 'day', 'date']
    df = pd.DataFrame(columns=columns)

    cwd = os.path.curdir
    for directory in args.directories:
        dir_path = '{}/{}'.format(cwd, directory)
        args.logger.info('opening directory "%s"', dir_path)
        for filename in glob.glob('{}/{}'.format(dir_path, args.regex)):
            # read first line to see if it is a header
            f = open(filename, 'r')
            flds = f.readline().split(',')
            try:
                float(flds[1])    # try to convert to number; fail if header
                encoding = 'old'
            except ValueError:
                encoding = 'new'
            args.logger.info('processing file "{}" ({})'.format(
                filename, encoding))
            f.close()
            df = df.append(process_file(filename, encoding))
    df.to_csv(args.output, index=False)


def main():
    '''
    creates a pandas data frame from the CSV files in a directory.
    '''
    parser = argparse.ArgumentParser(description=main.__doc__)
    parser.add_argument('-d', '--debug', action="count",
                        help='set debug level')
    parser.add_argument('-v', '--verbose', action="count",
                        help='set verbose level')
    parser.add_argument('-l', '--logfile', type=str, default='-',
                        help='set log file (default stderr "-")')
    parser.add_argument('-R', '--regex', type=str, default='*.txt',
                        help='regex for file name (default="*.txt")')
    parser.add_argument('-o', '--output', type=argparse.FileType('w'),
                        default=sys.stdout,
                        help='output file (default=stdout)')
    parser.add_argument('directories', type=str, nargs="+",
                        help='directories containing data files')
    args = parser.parse_args()

    logger = logging.getLogger()
    if args.logfile == '-':
        # send to stderr
        hdlr = logging.StreamHandler()
        formatter = logging.Formatter('%(message)s')
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
    run(args)


if __name__ == "__main__":
    main()
