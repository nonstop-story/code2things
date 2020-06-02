# -*- coding: utf-8 -*
import pymongo
import exam_fun
import asyncio

client = pymongo.MongoClient("mongodb://localhost:27000/")
# 链接数据库主机
data_base = client['test']
question = data_base['question']

question_file = open("file2.txt", "r")
for line in question_file:
    if line[0] != '1':
        continue
        # 弹幕成分判定
    array = line.split(':', 2)

    doc = {
        "uid": array[1],
        "danmaku": array[2].split('\n')[0],
    }

    exam_fun.insert_doc(doc, question)

question_file.close()
