# -*- coding: utf-8 -*
import pymongo

client = pymongo.MongoClient("mongodb://localhost:27017/")
data_base = client['test']
question = data_base['question']
uid_col = data_base['uid']
global regret_uid

try:
    while True:
        single = question.aggregate([{'$sample': {'size': 1}}])
        get = False
        for doc in single:
            get = True
            single = doc
        if not get:
            raise SystemExit("The database is NULL now")

        if single['finish'] == "yes":
            continue
        # 跳过已经完成的题目

        insert = True
        for result in uid_col.find({"uid": single['uid']}):
            insert = False
            continue
        # 趁另一个用户不注意提前插入文本
        # 防止两个用户同时改到一道题
        uid_col.insert_one({"uid": single['uid'], "type": "white"})
        regret_uid = single['uid']
        print(regret_uid)
        print('请问该言论是否引战，是请输入1，否请直接回车：')
        print(single['danmaku'])
        string = input()

        if string == '1':
            # 先 斩 后 奏
            uid_col.update_one({"uid": single['uid']}, {"$set": {"type": "black"}}, True)
        question.update_many({"danmaku": single['danmaku']}, {'$set': {'finish': 'yes'}}, True)
        question.update_many({'uid': single['uid']}, {'$set': {'finish': 'yes'}}, True)
        # 处理完该问题
        # 不再接受相同的问题
        # 以及相同用户的言论
except KeyboardInterrupt:
    print("用户终止进程")
    data_base['uid'].delete_many({'uid': regret_uid})
except SystemExit:
    print("数据库为空，程序已结束")
