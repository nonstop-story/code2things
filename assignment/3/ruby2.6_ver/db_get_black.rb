# -*- coding: utf-8 -*
# 从数据库获取黑名单保存为txt文件

require 'mongo'

client = Mongo::Client.new('mongodb://127.0.0.1:27017/test')
table = client[:uid]

black_file = File.new("database/new_black.txt", "wb")
table.find({type: "black"}).each do
|i|
  black_file.syswrite i['uid'] + "\n"
end
