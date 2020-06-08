import pymongo
import asyncio


def insert_doc(doc: dict, col: pymongo.collection.Collection):
    if_insert = True

    if doc["danmaku"]:
        for each in col.find({"danmaku": doc["danmaku"]}):
            if_insert = False
            break
    elif doc["uid"]:
        for each in col.find({"uid": doc["uid"]}):
            if_insert = False
            break

    if if_insert:
        col.insert_one(doc)
        print("insert: " + str(doc))
