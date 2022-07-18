from binance.spot import Spot
import time
import os
import requests
import json
from datetime import datetime
import logging

logging.basicConfig(format='%(asctime)s | %(message)s', level=logging.INFO)

api_key = os.environ['BAPI_KEY']
api_secret = os.environ['BAPI_SECRET']

bot_user = os.environ['BOT_USER']
bot_password = os.environ['BOT_PASSWORD']
coin_crawler_api_url = 'http://api/'
cc_api_keys = {}

client = Spot(key=api_key, secret=api_secret)

coins = []


def login_cc_api(username, password):
    r_u = coin_crawler_api_url + f'login?username={username}&password={password}'
    logging.info('Loggining in coin crawler api...')
    r = requests.post(r_u)
    if r.status_code == 200:
        logging.info('Login to coin crawler api successfull')
        keys = json.loads(r.content)
        return keys
    else:
        raise Exception('Connection to coin crawler api error')


def get_fresh_keys(keys):
    r_u = coin_crawler_api_url + 'refresh'
    if keys['expires_at'] < datetime.timestamp(datetime.utcnow())+2:
        logging.info('Trying to update keys...')
        r = requests.post(r_u, headers={'Accept': 'application/json', 'Authorization': f'Bearer {keys["access_token"]}'})
        if r.status_code == 200:
            logging.info('Updating keys successfull')
            keys = json.loads(r.content)
            return keys
        else:
            raise Exception('Connection to coin crawler api error')
    else:
        return keys


def get_coin_pairs_from_cc_api(keys):
    r_u = coin_crawler_api_url + 'get_all_coin_pairs'
    keys = get_fresh_keys(keys)
    logging.info('Getting coin pairs from coin crawler api...')
    r = requests.get(r_u, headers={'Accept': 'application/json', 'Authorization': f'Bearer {keys["access_token"]}'})
    if r.status_code == 200:
        logging.info('Getting coin pairs successfull')
        coin_pairs = json.loads(r.content)
        return coin_pairs
    else:
        raise Exception('Connection to coin crawler api error')


def sync_local_and_api_coin_pairs(local_coin_pairs, api_coin_pairs):
    result = []
    for a_cp in api_coin_pairs:
        is_cp_updated = False
        for l_cp in local_coin_pairs:
            if a_cp['short_name'] == l_cp['short_name']:
                l_cp.update(a_cp)
                result.append(l_cp)
                is_cp_updated = True
        if not is_cp_updated:
            a_cp.update({'period': '5m', 'ks': [], 'ds': []})
            result.append(a_cp)
    return result


def get_coin_pairs(keys, local_cp):
    api_cp = get_coin_pairs_from_cc_api(keys)
    return sync_local_and_api_coin_pairs(local_cp, api_cp)


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


if __name__ == "__main__":
    time.sleep(2)
    logging.info('Bot launched')
    cc_api_keys = login_cc_api(bot_user, bot_password)
    time.sleep(2)
    print(get_coin_pairs(cc_api_keys, coins))
    # for _ in range(2):
    #     for coin in coins:
    #         print(f'------calc coin {coin["name"]}------')
    #         calc_coin_data(coin)
    #         print(f'------------------------------------')
    #     time.sleep(60)




# Get server timestamp
# print(client.time())
# # Get klines of BTCUSDT at 1m interval
# 
# # Get last 10 klines of BNBUSDT at 1h interval
# print(client.klines("BNBUSDT", "1h", limit=10))

# api key/secret are required for user data endpoints


# Get account and balance information
# print(client.account())