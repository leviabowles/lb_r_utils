import tweepy
import time
import pandas as pd
import os
import warnings
warnings.filterwarnings("ignore")


api = tweepy.API(auth)



df = pd.read_csv(fp, dtype={'id': str})
listo = df['id'].to_list()

for ID in listo[5:30]:
    try: 
        api.destroy_status(ID)
        time.sleep(15)
        print(ID)
    except:
        print(ID)
