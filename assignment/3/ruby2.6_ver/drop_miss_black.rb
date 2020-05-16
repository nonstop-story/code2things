# -*- coding: utf-8 -*
# 对于所有的黑名单
# 在一个个confirm后
# 会删除误处理的uid

require 'mongo'

client = Mongo::Client.new('mongodb://127.0.0.1:27017/test')
table = client[:uid]

miss_black_file = File.open("database/drop_list.txt", "rb")

if miss_black_file
  miss_black_file.each_line do
  |miss|
    miss.delete! "\n"
    # 为了保险删除换行符

    unless miss
      # 如果因为意外某行为空则跳过
      next
    end
    # 误处理黑名单的恢复
    table.delete_many({:uid => miss})
  end
end