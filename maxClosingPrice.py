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
start_dt = end_dt - relativedelta.relativedelta(days=365)
filename = "ClosePrice.csv"
if os.path.exists(filename):
    os.remove(filename)
else:
    print("target file is not present")

for key in stock_dict:
    stock = key
    print(stock)
    data = nsepy.get_history(symbol=key,start=start_dt,end=end_dt)
    # data = data[['Symbol', 'High', 'Low', 'Close','Prev Close']]
    data = data[['Symbol', 'Close']]
    if not data.empty:
        maxVol = data["Close"].max()
        maxVol_df = data[data.Close == maxVol]
        maxVol_df.to_csv(filename,mode='a',header=False)

print(datetime.datetime.now())
#Dinak,Symbol,CP
