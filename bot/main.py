from binance.spot import Spot
import time

api_key = 'r4k9lLkv0wTIYL5R8e7vCH53G4BqWhgJVg0VVMcCDKlqKVKsl0tAy82slKlNdFEt'
api_secret = '2Sa45sHIV07RT49dOgJPfCihl623ArdOiHt77pUf4yUw2HRPleTMyWPOw8Oxv364'

client = Spot(key=api_key, secret=api_secret)

coins = [{'name': 'MATICBUSD', 'period': '5m', 'ks': [], 'ds': []}]


def get_candle(coin, period):
    c = client.klines(coin, period, limit=1)[0]
    candle = {'open_time': c[0], 'close_time': c[6], 'open': float(c[1]), 'close': float(c[4]), 'high': float(c[2]), 'low': float(c[3])}
    return candle

def calc_ks(ks, candle):
    k = round(100 * (candle['close'] - candle['low']) / (candle['high'] - candle['low']), 2)
    if len(ks) > 4:
        ks.pop(0)
    ks.append(k)
    return ks

def calc_d(ks, ds):
    d = round(sum(ks)/len(ks), 2)
    if len(ds) > 4:
        ds.pop(0)
    ds.append(d)
    return ds

def calc_coin_data(coin):
    candle = get_candle(coin['name'], coin['period'])
    coin['ks'] = calc_ks(coin['ks'], candle)
    coin['ds'] = calc_d(coin['ks'], coin['ds'])
    candle.update({'k': coin['ks'][len(coin['ks'])-1], 'd': coin['ds'][len(coin['ds'])-1]})
    print(candle)
    print(coin['ks'])
    print(coin['ds'])

for _ in range(10):
    for coin in coins:
        print(f'------calc coin {coin["name"]}------')
        calc_coin_data(coin)
        print(f'------------------------------------')
    time.sleep(60)




# Get server timestamp
# print(client.time())
# # Get klines of BTCUSDT at 1m interval
# 
# # Get last 10 klines of BNBUSDT at 1h interval
# print(client.klines("BNBUSDT", "1h", limit=10))

# api key/secret are required for user data endpoints


# Get account and balance information
# print(client.account())