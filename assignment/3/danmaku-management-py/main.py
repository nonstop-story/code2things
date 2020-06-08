#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import asyncio
import json
import os

import requests
from ki_logger import Logger
import blivedm
import cookies as cookies_getter


async def set_block_user(room_id, csrf, user_uid):
    block_url = "https://api.live.bilibili.com/banned_service/v2/Silent/add_block_user"
    headers = {"content-type": "application/x-www-form-urlencoded"}
    data = f"roomid={room_id}&block_uid={user_uid}&hour=720&csrf_token={csrf}&csrf={csrf}&visit_id="
    block_it = requests.post(block_url, data=data, cookies=cookies, headers=headers)
    return json.loads(block_it.text)


async def judge(danmaku_content):
    for _ in black:
        if _ in danmaku_content:
            return True


class MyBLiveClient(blivedm.BLiveClient):
    # 演示如何自定义handler
    _COMMAND_HANDLERS = blivedm.BLiveClient._COMMAND_HANDLERS.copy()
    repeat_list = []

    async def _on_receive_danmaku(self, danmaku: blivedm.DanmakuMessage):

        if danmaku.msg_type == 0:
            if await judge(danmaku.msg):
                mes = await set_block_user(room, my_csrf, danmaku.uid)
                if mes['code'] == 0:
                    Logger.log(f"已禁言: {danmaku.uname} 他的uid为: {danmaku.uid} 他的弹幕为: {danmaku.msg}")
            Logger.log(f"{danmaku.timestamp}:{danmaku.uid}:{danmaku.msg}")


async def main():
    # 参数1是直播间ID
    # 如果SSL验证失败就把ssl设为False
    client = MyBLiveClient(room, ssl=True)
    future = client.start()

    try:
        await future
    finally:
        await client.close()


if __name__ == '__main__':
    room = int(input("请输入房间号："))
    Logger.init(9999)
    Logger.log("程序将请求您的cookies信息，请允许")
    cookies = cookies_getter.get_bilibili_cookies()
    my_csrf = cookies['bili_jct']
    black = []
    if os.path.exists("./black.txt"):
        file = open("./black.txt", "r")
        for line in file:
            line = line.split()[0]
            if line:
                black.append(line)
        file.close()
    asyncio.get_event_loop().run_until_complete(main())
