# -*- coding: utf-8 -*
import pymongo

client = pymongo.MongoClient("mongodb://localhost:27000/")
data_base = client['test']
question = data_base['question']
finished_question = data_base['finished_question']
uid_col = data_base['uid']
global regret_uid

try:
    while True:
        single = question.aggregate([{'$sample': {'size': 1}}])
        get_question = False
        for doc in single:
            get_question = True
            single = doc
        if not get_question:
            raise SystemExit("The database is NULL now")

        insert = True
        for result in uid_col.find({"uid": single['uid']}):
            insert = False
            continue
        """
        趁另一个用户不注意提前插入文本
        防止两个用户同时改到一道题
        """
        uid_col.insert_one({"uid": single['uid'], "type": "white"})
        regret_uid = single['uid']
        print(regret_uid)
        print('请问该言论是否引战，是请输入1，否请直接回车：')
        print(single['danmaku'])
        string = input()

        if string == '1':
            '''
            先 斩 后 奏
            即：先将其加入白名单
            发现是引战弹幕后
            将其更新为黑名单
            '''
            uid_col.update_one({"uid": single['uid']}, {"$set": {"type": "black"}}, True)

        finished_list_1 = question.find({"danmaku": single['danmaku']})
        finished_list_2 = question.find({'uid': single['uid']})

        for one in finished_list_1:
            del one["_id"]
            finished_question.insert_one(one)
            question.delete_many({"danmaku": one["danmaku"]})

        for one in finished_list_2:
            del one["_id"]
            finished_question.insert_one(one)
            question.delete_many({"uid": one["uid"]})
        """
        处理完该问题
        不再接受相同的问题
        以及相同用户的言论
        """
except KeyboardInterrupt:
    print("用户终止进程")
    data_base['uid'].delete_many({'uid': regret_uid})
except SystemExit:
    print("数据库为空，程序已结束")
