#-*- coding: utf-8 -*
# 将处理后的弹幕文件喂进数据库

require 'mongo'

client = Mongo::Client.new('mongodb://127.0.0.1:27017/test')
table = client[:question]

question_file = File.open("database/file2.txt", "rb")

if question_file
  question_file.each_line do
  |question|
    question.delete! "\n"
    # 为了保险删除换行符

    unless question[0] == '1'
      # 只有该行是弹幕文件才进行输入
      next
    end

    array = question.split(":", 3)
    danmaku_content = array[2].force_encoding("utf-8")
    # 保险起见进行强制编码一次

    insert = true
    doc = {
        uid: array[1],
        danmaku: danmaku_content,
        finish: "no"
    }

    table.find({:danmaku => danmaku_content}).each do
      insert = false
    end
    if insert
      table.insert_one(doc)
    end

  end
end
question_file.close