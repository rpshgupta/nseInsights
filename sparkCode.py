import urllib.request
ticker = 'INFY'
url = 'https://www.nseindia.com/live_market/dynaContent/live_watch/get_quote/GetQuote.jsp?symbol='+ticker+'&illiquid=0&smeFlag=0&itpFlag=0'
print(url)
req = urllib.request.Request(url, headers={'User-Agent' : "Chrome Browser"})
print(req)
fp = urllib.request.urlopen(req, timeout=30)
print(fp)
mybytes = fp.read()
print(mybytes)
mystr = mybytes.decode("utf8")
print(mystr)
fp.close()
