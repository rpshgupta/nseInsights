import nsepy
import datetime
import nsetools
from dateutil import relativedelta

nse = nsetools.Nse()
stock_dict = nse.get_stock_codes()
del stock_dict['SYMBOL']
# stock_dict = ["SBIN"]

end_dt = datetime.date.today() - relativedelta.relativedelta(days=1)
start_dt = end_dt - relativedelta.relativedelta(days=365)
# print(end_dt)
#print(start_dt)


for key in stock_dict:
    symbol = key
    # print(symbol)
    data = nsepy.get_history(symbol=symbol, start=start_dt, end=end_dt)
    if not data.empty:
        max_closing = data['Volume'].max()
        max_closing_df = data[data.Volume == max_closing]
        max_closing_dt = max_closing_df.index.values[0]
        dt = datetime.datetime.strftime(max_closing_dt, "%Y-%m-%d")
        if str(dt) == str(end_dt):
            print(symbol)
