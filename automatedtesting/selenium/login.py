# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.chrome.service import Service

import time


def login (user, password):
    print ('Starting the browser...')
    # --uncomment when running in Azure DevOps.
    options = ChromeOptions()
    options.add_argument("headless")
    options.add_argument("--no-sandbox")
    options.add_argument("---remote-debugging-port=9222")
    options.add_argument("--disable-extensions") 
    options.add_argument("--disable-gpu") 
    options.add_argument("start-maximized")
    options.add_experimental_option("detach", True)
    options.add_experimental_option('excludeSwitches', ['enable-logging'])
    driver = webdriver.Chrome('./chromedriver', options=options) #only when runnning in Linux!
    # driver = webdriver.Chrome(ChromeDriverManager().install())

    print ('Browser started successfully. Navigating to the demo page to login.')
    driver.get('https://www.saucedemo.com/')
    print ('Login attempt, user: {},  password: {}'.format(user, password))
    driver.find_element("css selector","input[id='user-name']").send_keys(user)
    driver.find_element("css selector","input[id='password']").send_keys(password)
    time.sleep(2)  
    driver.find_element("css selector","input[id='login-button']").click()
    our_search = driver.find_element("css selector","div[id='header_container'] > div[class='header_secondary_container'] > span.title").text

    assert our_search == "PRODUCTS"

    if (our_search == "PRODUCTS"):
        print ('Login Success.')
    
    else:
        print("unable to confirm that login has been succesfull")


    items = ["sauce-labs-backpack","sauce-labs-bike-light","sauce-labs-bolt-t-shirt","sauce-labs-fleece-jacket","sauce-labs-onesie","test.allthethings()-t-shirt-(red)"]

    print("attempt to add products to the cart now")

    for i in items:
        print("adding " + i + " to the cart now...")
        driver.find_element("xpath","//*[@id='add-to-cart-{0}']".format(i)).click()
        
    time.sleep(3)
    print("adding items to the cart has finished, removing them again now...")

   
    for i in items:
        print("removing " + i + " from the cart now...")
        driver.find_element("xpath","//*[@id='remove-{0}']".format(i)).click()

    driver.quit()

login('standard_user', 'secret_sauce')