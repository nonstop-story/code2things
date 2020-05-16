# -*- coding: utf-8 -*

white_str = {"ぺこ", "待機", "待机", "O", "o", "k", "K", "草", "888", "114", "大丈夫", "理解",
             "辛苦了", "WW", "ww", "ペコ", "导游", "房管", "完全一致", "复刻", "い", "天才",
             "上手", "回线", "网络", "来了", "\\", "/", "晚安", "【", "お", "pr", "こ",
             "８８８", "危", "恭喜", "）", ")", "(", "（"}
# 白名单列表

file = open("file.txt", "r")
new_file = open("file2.txt", "w")
for line in file:
    skip = False
    for white in white_str:
        if white in line:
            skip = True
            break
    if not skip:
        print(line)
        new_file.writelines(line)
file.close()
new_file.close()
