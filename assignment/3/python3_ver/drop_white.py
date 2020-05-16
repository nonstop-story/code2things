# -*- coding: utf-8 -*
import pymongo

client = pymongo.MongoClient("mongodb://localhost:27017/")
data_base = client['test']
uid_col = data_base['uid']

uid_col.delete_many({"type": "white"})
