# -*- coding: utf-8 -*
import pymongo

client = pymongo.MongoClient("mongodb://localhost:27017/")
data_base = client['test']
question = data_base['question']
uid_col = data_base['uid']

uid_list = uid_col.find({'type': "black"})
file = open("confirm_list.txt", "w")

for uid in uid_list:
    file.writelines(uid['uid'] + "\n")
    question_list = question.find({'uid': uid['uid']})
    for single in question_list:
        file.writelines(single['danmaku'] + "\n")
    file.writelines('\n')

file.close()
