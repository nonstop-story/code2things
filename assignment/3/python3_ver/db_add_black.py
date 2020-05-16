# -*- coding: utf-8 -*
import pymongo

client = pymongo.MongoClient("mongodb://localhost:27017/")
data_base = client['test']
uid_col = data_base['uid']

black_file = open("black.txt", "r")
for line in black_file:
    if not line.split("\n")[0]:
        continue
    uid = line.split("\n")[0]
    doc = {
        "uid": uid,
        "type": "black"
    }
    insert = True
    for result in uid_col.find({"uid": uid}):
        insert = False
        print("not insert " + uid)
    if insert:
        uid_col.insert_one(doc)
        print("insert " + uid)
black_file.close()
