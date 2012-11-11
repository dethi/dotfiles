#!/usr/bin/env python3
# -*-coding:Utf-8 -*
#
# Test the internet connection every 5 mins and log status change 
# (connected/disconnected)
#
# Syntax:
# ./test_connect.py
#
#
# Copyright (C) 2012 Deutsch Thibault <thibault.deutsch@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#

__APPNAME__ = "Test Connection"
__VERSION__ = "0.1.0"
__AUTHOR__ = "Deutsch Thibault <thibault.deutsch@gmail.com>"
__WEB__ = "http://www.thionnux.fr/"
__LICENCE__ = "GPL"


# Libraries
#-----------------------------------------------------------------------------

import http.client
import time
import logging
import signal
import sys


# Functions
#-----------------------------------------------------------------------------

def test_connection(x):
    for elt in range(x):
        connect = http.client.HTTPConnection("www.google.fr")
        try:
            connect.request("HEAD", "/")
        except:
            print("FALSE")
            return False
    print("TRUE")
    return True
    
def quit_app(signal, frame):
    logging.info("Arrêt du programme.")
    sys.exit(0)
            
def main():
    signal.signal(signal.SIGINT, quit_app)
    logging.basicConfig(format='[%(asctime)s] %(levelname)s : %(message)s',
        datefmt='%d/%m/%Y %H:%M:%S', level=logging.DEBUG,
        filename='acces_internet.log')
    logging.info('Démarrage du programme.')
    internet = True
    n = 0
    while True:
        last_test = internet
        d = time.strftime("%d/%m/%Y %H:%M:%S")
        n += 1
        print("[{}] Requête n°{} : ".format(d, n), end="")
        internet = test_connection(1)
        if internet != last_test:
            if internet:
                logging.warning('Accès internet rétablie.')
            else:
                logging.warning('Pas d\'accès internet.')
        time.sleep(300)
        
if __name__ == "__main__":
    main()

