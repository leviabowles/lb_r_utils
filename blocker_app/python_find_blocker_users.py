
import tweepy
import time
import pandas as pd
import os
from afinn import Afinn
afinn = Afinn()
import numpy as np


import warnings
warnings.filterwarnings("ignore")


api = tweepy.API(auth)


def get_blocked_users(ud_name):
    ids = []
    for page in tweepy.Cursor(api.followers_ids, screen_name=ud_name).pages():
        ids.extend(page)
        print len(ids)
        time.sleep(60)
    cou = 1
    catcher = pd.DataFrame(columns=["user_id", "status", "description"])
    for ix in ids:
        try:
            used = api.get_user(ix)
        except: next
        try:
            my_tweets = api.user_timeline(ix)
            outs = "not blocked"
        except:
            jj = sys.exc_info()[1]
            if jj.api_code == 136:
                outs = "blocked"
            else:
                jj = sys.exc_info()[1]
                outs = "other_error"
                print sys.exc_info()
        ud = pd.DataFrame([[used.screen_name, outs, used.description]], columns=["user_id", "status", "description"])
        catcher = catcher.append(ud)
        if cou % 50 == 0:
            to_con = catcher.query('status == "blocked"')
            print(to_con)
            print cou
        cou = cou + 1
        time.sleep(1)

    os.chdir('C:\Users\lbowle11\Documents\\blocky')
    catcher.to_csv(ud_name + '.csv', encoding='utf-8')



dld = ["HardRotCafe" ,    "ChrisSturr"  ,    "cmarslett"    ,   "Serafina2112"   ,
    "maryepworth" ,    "Mover2100" ,      "ThroughABellJar", "nerkles"     ,
    "Wind2Energy"  ,   "buznbyu"    ,     "KnightRheidyr" ,  "RebeccaSWH",
    "CutTheTreacle"  , "midUSAmom"  ,     "perkpowe"  ,      "renmiri1"       ,
    "SandraL" ,        "danmonaghan"   ,  "Laura_Exley2" ,   "Robin_Resists"  ,
    "CaNettoyant"  ,   "WholePlateWay" ,  "claudiamiles" ,   "sandrajcooper"]

for accte in dld:
    get_blocked_users(accte)







os.chdir('C:\Users\lbowle11\Documents\\blocky')
import glob
xx = pd.DataFrame(columns=["user_id", "status", "description", "ou"])
for files in glob.glob("*.csv"):
    dlm = pd.read_csv(files)
    dlm['ou'] = files
    xx = xx.append(dlm)

accx = ["foggybottomgal",  "BDBoopster" ,     "socflyny"   ,     "lfkraus"  ,       "chrisfayers"]
for acc in accx:
    get_blocked_users(acc)


xx['color'] = np.where(xx['status'] == 'blocked', 1, 0)
xx.groupby(['ou']).mean()


xx = pd.read_csv('livetweettweet.csv')

xkc = xx[(xx.status == 'blocked')]
mm = xkc.user_id
loo = mm.unique()

for j in loo:
    print j
    get_blocked_users(j)


ids = []

for page in tweepy.Cursor(api.followers_ids, screen_name="SenatorKelly").pages():
    ids.extend(page)
    print len(ids)
    time.sleep(60)


for ix in ids[1:5]:
    try:
        used = api.get_user(ix)
        print used
    except: next

if tweets.created_at >= EarliestTweet:
    # Write it to a file
    json.dump(used._json, jsonfile, sort_keys=True, skipkeys=True, indent=2, ensure_ascii=False)

tweet_list = []
for tweet in tweets:
    tweet_list.append(tweet._json)
