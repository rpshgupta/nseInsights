import pandas as pd
import glob
# files = glob.glob("C:\\Users\\171575\\PycharmProjects\\pythonProject\\hist_data\\*.csv")
files = glob.glob("C:\\Users\\171575\\PycharmProjects\\pythonProject\\files\\*.csv")
df = pd.DataFrame()
for f in files:
    csv = pd.read_csv(f)
    print(csv)
    print(type(csv))
    # df = df.append(csv)
# df.to_csv("1.csv",index=False)
# print(df)