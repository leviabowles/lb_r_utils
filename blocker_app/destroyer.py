import tweepy
import time
import pandas as pd
import os
import warnings
warnings.filterwarnings("ignore")

## insert path to csv of tweet ids
fp = ''

api = tweepy.API(auth)



df = pd.read_csv(fp, dtype={'id': str})
listo = df['id'].to_list()

for ID in listo:
    try: 
        api.destroy_status(ID)
        time.sleep(15)
        print(ID)
    except:
        print('failed destruction')
        print(ID)
