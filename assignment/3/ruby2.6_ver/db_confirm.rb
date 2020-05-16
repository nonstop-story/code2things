#-*- coding: utf-8 -*
# 根据黑名单输出这个人发的弹幕

require 'mongo'

client = Mongo::Client.new('mongodb://127.0.0.1:27017/test')
uid_col = client[:uid]
question = client[:question]
confirm_file = File.new("database/confirm_list.txt", "wb")

uid_col.find({type: "black"}).each do
|i|
  confirm_file.syswrite "#{i["uid"]}\n"
  question.find({:uid => i['uid']}).each do
  |line|
    confirm_file.syswrite line['danmaku']
  end
  confirm_file.syswrite "\n"
end
confirm_file.close