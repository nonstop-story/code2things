# -*- coding: utf-8 -*
import pymongo

client = pymongo.MongoClient("mongodb://localhost:27017/")
data_base = client['test']
uid_col = data_base['uid']

black_file = open("new_black.txt", "w")
for uid in uid_col.find({"type": "black"}):
    black_file.writelines(uid["uid"] + "\n")
black_file.close()
