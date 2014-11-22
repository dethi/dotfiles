#!/usr/bin/env python
#
# The MIT License (MIT)
#
# Copyright (c) 2014 Thibault Deutsch <thibault.deutsch@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import sys
import atexit
import time
import requests

REFRESH_TIME = 15 * 60 # 15 min
DATA_FILE = os.path.expanduser("~/.wiki-prog-revid")
API_URL = "http://wiki-prog.infoprepa.epita.fr/api.php? \
    action=query&list=recentchanges&rclimit=1&format=json"

def main():
    print("=== Start wiki_prog_notif ===")
    oldrevid = read_id()

    while 1:
        json = api_request_json(API_URL)
        if json is not None:
            revid = json['query']['recentchanges'][0]['revid']
            if revid > oldrevid:
                oldrevid = revid
                write_id(revid)
                t = json['query']['recentchanges'][0]['timestamp']
                t = t.replace('T', ' ')
                t = t.replace('Z', '')
                print("[NEW] {} => {}".format(revid, t))
                beep()

        try:
            time.sleep(REFRESH_TIME)
        except (KeyboardInterrupt, SystemExit):
            print("[INFO] Received keyboard interrupt", file=sys.stderr)
            sys.exit(0)

def beep():
    sys.stdout.write('\a')
    sys.stdout.flush()

def api_request_json(url):
    try:
        r = requests.get(url)
        return r.json()
    except:
        print("[ERROR] Network issue", file=sys.stderr)

def read_id():
    data = None
    try:
        with open(DATA_FILE, 'r') as f:
            data = f.read()
    except:
        data = 0
        print("[INFO] Created file: {}".format(DATA_FILE), file=sys.stderr)
    return int(data)

def write_id(revid):
    with open(DATA_FILE, 'w') as f:
        f.write(str(revid))

@atexit.register
def goodbye():
    print("=== Goodbye ! ===")

if __name__ == '__main__':
    main()
