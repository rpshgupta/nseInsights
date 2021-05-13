import nsepy
import datetime
from dateutil import relativedelta
import pandas
# import cx_oracle
import os
import nsetools
print(datetime.datetime.now())
nse = nsetools.Nse()
stock_dict = nse.get_stock_codes()
del stock_dict['SYMBOL']
# stock_dict = ["INFY"]
pandas.set_option('display.max_rows',None)
end_dt = datetime.date.today()
start_dt = end_dt - relativedelta.relativedelta(days=0)

for key in stock_dict:
    stock = key
    print(stock)
    path = "C:\\Users\\171575\\PycharmProjects\\pythonProject\\hist_data"
    data = nsepy.get_history(symbol=key,start=start_dt,end=end_dt)
    # print(data)
    data.to_csv("{}.csv".format(stock),mode='a',header=False)
print(datetime.datetime.now())
