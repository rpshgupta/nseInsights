
import datetime
from dateutil import relativedelta
import pandas as pd
import os
import glob

print(datetime.datetime.now())
end_dt = datetime.date.today()
start_dt = end_dt - relativedelta.relativedelta(days=365)

filename = "my.csv"
if os.path.exists(filename):
    os.remove(filename)
else:
    print("target file is not present")

files = glob.glob("C:\\Users\\171575\\PycharmProjects\\pythonProject\\hist_data\\*.csv")
df = pd.DataFrame()
for f in files:
    print(f)
    data = pd.read_csv(f)
    data = data[['Date','Symbol', 'High', 'Low', 'Close','Prev Close', 'Volume', 'Trades']]
    data["High-Low"] = data["High"] - data["Low"]
    data["High-Prev Close"] = abs(data["High"]-data["Prev Close"])
    data["Low-Prev Close"] = abs(data["Low"]-data["Prev Close"])
    data["tr"] = data[["High-Low","High-Prev Close","Low-Prev Close"]].max(axis=1)
    data["atr"] = data["tr"].rolling(7).mean()
    data["upper-band"] = (((data["High"]+data["Low"])/2) + (3 * data["atr"]))
    data["lower-band"] = (((data["High"]+data["Low"])/2) - (3 * data["atr"]))
    data['in-uptrend'] = 1

    for current in range(1,len(data.index)):
        previous = current - 1

        if data["Close"][current] > data["upper-band"][previous]:
            data['in-uptrend'][current] = 1
        elif data["Close"][current] < data["lower-band"][previous]:
            data['in-uptrend'][current] = 0
        else:
            data["in-uptrend"][current] = data["in-uptrend"][previous]
            if data["in-uptrend"][current] and data["lower-band"][current] < data["lower-band"][previous]:
                data["lower-band"][current] =data["lower-band"][previous]
            if not data["in-uptrend"][current] and data["upper-band"][current] > data["upper-band"][previous]:
                data["upper-band"][current] =data["upper-band"][previous]


    data = data[['Date','Symbol', 'High', 'Low', 'Close', 'Prev Close', 'Volume', 'Trades', 'in-uptrend']]
    df = df.append(data)

df.to_csv(filename,index=False)
print(datetime.datetime.now())
