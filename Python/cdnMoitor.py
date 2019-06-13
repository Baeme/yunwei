# /usr/bin/env python
# @ sjie


import subprocess
import requests
import json


class PingResult:
    def __init__(self, url):
        self.url = url

    def UrlResult(self):
        Result = subprocess.Popen("ping -w 1 %s >/dev/null;echo $?", stdout=subprocess.PIPE, shell=True)
        statuscode = Result.stdout.read().rstrip().decode('utf-8')
        return statuscode


class DingTalk():
    def __init__(self, DingTalkUrl, message):
        self.DingTalkUrl = DingTalkUrl
        self.message = message
    
    def PostMessage(self):
        headers = {'Content-Type': 'application/json'}
        req = requests.post(self.DingTalkUrl, data=json.dumps(self.message), headers=headers)
        return req


if __name__ == "__main__":
    urllist = ["",""]
    DingdingWebHook = ""
    for i in range(len(urllist)):
        Instacestatus = PingResult(urllist[i])
        status = Instacestatus.UrlResult()
        if status != "0":
            message = {"msgtype": "markdown", "markdown": {
                "title": "CDN监控", "text": "#### CDN监控\n" + "- 异常CDN地址: %s\n" % (urllist[i]) }}
            Post = DingTalk(DingdingWebHook, message)
            print(Post.PostMessage())

