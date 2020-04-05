import sys
import os
import glob
import argparse
import logging
import logging.handlers
import pandas as pd

def convertToDateNew(date_str):
    # format is MM/DD/YYYY
    format = "%m/%d/%Y"
    datetime = pd.to_datetime(date_str, format=format)
    return datetime

def process_file(file_name):

    df = pd.read_csv(file_name, usecols=[0, 1, 4, 6, 7],skipfooter = 1, engine = 'python')
    df['Time'] = df['Time'].apply(convertToDateNew)
    df = df.rename(columns={'Open': "open", 'Last': "close", 'Time': "date", 'Volume': "volume", 'Open Int': "openint"})
    enddate = df['date'].iloc[0]
    compute_days = lambda x:(enddate - x).days
    df['day'] = df["date"].apply(compute_days)
    # df_copy = df.copy()
    days_max = df["day"].iloc[-1]
    final_close = df['close'].iloc[0]

    # insert "missing days"
    df2 = pd.DataFrame(columns=['open', 'close', 'open_net', 'close_net',
                                'open_rel', 'close_rel', 'volume',
                                'openint', 'day', 'date'])
    last = 1
    #print(df)
    for i in range(len(df)):
        #if i!=0:
        #    rowprev=df.iloc[i-1]
        day = df.iloc[i]['day']
        row = df.iloc[i]
        row = row.copy()
        row['open_net'] = row['open'] - final_close
        row['close_net'] = row['close'] - final_close
        row['open_rel'] = row['open'] / final_close
        row['close_rel'] = row['close'] / final_close
        # insert this row and "missing days", eg, weekends and holidays
        #print(row)
        if row['day']-df.iloc[i-1]['day']>1:
            for k in range(day-last):
                row = row.copy()
                row['day'] = last + 1 + k
                df2 = df2.append(row)
        else:
            df2 = df2.append(row)
        last = day

    df2.insert(loc=0, column='month', value=enddate.month)
    df2.insert(loc=0, column='year', value=enddate.year)
    return df2

def convertdata():
    columns = ['year', 'month', 'open', 'close', 'open_net', 'close_net', 'open_rel', 'close_rel', 'volume', 'openint', 'day', 'date']
    df = pd.DataFrame(columns=columns)
    for filename in glob.glob("C:/Users/S.Nishitha/Desktop/pd/Barchart Data/SOY/*.csv"):
        df = df.append(process_file(filename))
    df.to_csv (r'C:\Users\S.Nishitha\Desktop\pd\export_dataframe.csv', index = False, header=True)
        
if __name__ == "__main__":
    convertdata()