# -*- coding: utf-8 -*
import pymongo

client = pymongo.MongoClient("mongodb://localhost:27017/")
data_base = client['test']
uid_col = data_base['uid']

black_miss_file = open("drop_list.txt", "r")

for line in black_miss_file:
    line = line.split("\n")[0]

    if not line:
        continue
    uid_col.delete_many({"uid": line})

black_miss_file.close()
