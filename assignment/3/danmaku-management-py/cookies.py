#!/usr/bin/env python3
# coding=utf-8

import browser_cookie3

def get_bilibili_cookies():
    cookies = browser_cookie3.chrome()
    result = {}
    for one in cookies:
        if "bilibili" in one.domain and one.name not in result.keys():
            result[one.name] = one.value
    return result

