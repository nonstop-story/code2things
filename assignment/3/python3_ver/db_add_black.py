# -*- coding: utf-8 -*
import pymongo
import exam_fun

client = pymongo.MongoClient("mongodb://localhost:27000/")
# 连接服务器
data_base = client['test']
uid_col = data_base['uid']

black_file = open("black.txt", "r")
for line in black_file:
    if not line.split("\n")[0]:
        continue
        # 跳过空名单
    """
    去除换行符
    构建插入文档
    """
    uid = line.split("\n")[0]
    doc = {
        "uid": uid,
        "type": "black"
    }
    """
    进行查重判定
    以及插入行为
    """
    exam_fun.insert_doc(doc, uid_col)

black_file.close()
