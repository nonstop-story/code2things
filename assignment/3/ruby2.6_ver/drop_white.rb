# -*- coding: utf-8 -*
# 删除数据库中已经存在的白名单

require 'mongo'

client = Mongo::Client.new('mongodb://127.0.0.1:27017/test')
table = client[:uid]

table.delete_many({:type => "white"})