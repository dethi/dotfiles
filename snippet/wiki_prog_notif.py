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

from __future__ import print_function
import os
import sys
import time
import requests
import smtplib
from email.mime.text import MIMEText

SMTP = 'localhost'
SENDER = 'script@dethi.ovh'
RECEIVERS = 'thibault.deutsch@epita.fr'

DATA_FILE = os.path.expanduser("~/.wiki-prog-revid")
API_URL = "http://wiki-prog.infoprepa.epita.fr/api.php? \
    action=query&list=recentchanges&rclimit=1&format=json"

def main():
    oldrevid = read_id()
    json = api_request_json(API_URL)
    json = json['query']['recentchanges'][0]
    
    if json is None:
        return
        
    revid = json['revid']
    if revid > oldrevid:
        oldrevid = revid
        write_id(revid)
        t = json['timestamp']
        t = t.replace('T', ' ')
        t = t.replace('Z', '')
        
        msg = MIMEText('{}\nhttp://wiki-prog.infoprepa.epita.fr/'.format(
            json['title']))
        msg['To'] = RECEIVERS
        msg['From'] = SENDER
        msg['Subject'] = '[wiki-prog] {}'.format(json['type'])
        
        send_mail(msg.as_string())
        print("[NEW] {} => {}".format(revid, t))

def api_request_json(url):
    try:
        r = requests.get(url)
        return r.json()
    except:
        print("[ERROR] Network issue", file=sys.stderr)

def send_mail(msg, sender=SENDER, receivers=RECEIVERS, smtp=SMTP):
    try:
        conn = smtplib.SMTP(smtp)
        conn.sendmail(sender, receivers, msg)
        conn.quit()
        print("[INFO] Successfully sent email")
    except:
        print("[ERROR] Unable to send email", file=sys.stderr)

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

if __name__ == '__main__':
    main()
