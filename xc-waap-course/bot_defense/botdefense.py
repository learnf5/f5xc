"""Juice Shop Bot defense test v1.1 P.Kuligowski 9/9/2022"""

import sys
import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager


url = "https://" + sys.argv[1] + "/#/login"
browser = webdriver.Chrome(service=Service(ChromeDriverManager().install()))
time.sleep(2)
credentialsFile = open('./data/credentials.txt', 'r')
credentials = credentialsFile.readlines()


def main(credentials):
    a = 1
    try:
        for line in credentials:
            print(line)
            credentialPairs = line.rstrip()
            both = credentialPairs.split(':')
            password = both.pop()
            login = both.pop()
            print('---------------------------------------------------')
            print('Login: ' + login)
            print('Password: ' + password)
            browser.get(url)
            """Fix to accept cookies and remove Welcome Page"""
            if a == 1:
                """Accept Cookies only once"""
                browser.find_element(by=By.XPATH, value='/html/body/div[1]/div/a').click()
                time.sleep(2)
                """Accept Welcome page only once"""
                browser.find_element(by=By.XPATH,value='//*[@id="mat-dialog-0"]/app-welcome-banner/div/div[2]/button[2]').click()
                a -= 1
            browser.find_element(by=By.NAME, value="email").send_keys(login)
            browser.find_element(by=By.NAME, value="password").send_keys(password)
            time.sleep(0.1)
            element = browser.find_element(by=By.XPATH, value='//*[@id="loginButton"]/span[1]')
            browser.execute_script("arguments[0].click();", element)
            time.sleep(1.0)
            title = browser.title          
            if 'Account Information' in title:
                print('Login Success!')
            else:
                print('Login Failure!')
            time.sleep(2)
    except KeyboardInterrupt:
        print('---------------------------------------------------')
        print("Bye!")
        sys.exit()


if __name__ == "__main__":
    print(main(credentials))