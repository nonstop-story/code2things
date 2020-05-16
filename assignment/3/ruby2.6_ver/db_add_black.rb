# 将现成的黑名单喂进数据库
require 'mongo'

client = Mongo::Client.new('mongodb://127.0.0.1:27017/test')
table = client[:uid]

black_file = File.open("database/black.txt", "rb")

if black_file
  black_file.each_line do
  |black_id|
    black_id = black_id.delete! "\n"
    # 为了保险删除换行符

    unless black_id
      # 如果因为意外某行为空则跳过
      next
    end
    insert = true

    doc = {
        uid: black_id,
        type: "black"
    }

    table.find({:uid => black_id}).each do
      insert = false
    end
    if insert
      table.insert_one(doc)
    end

  end
end
black_file.close
