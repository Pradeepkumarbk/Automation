import time
import random
from selenium import webdriver

class web():
    driverpath = "/usr/bin/chromedriver"
    driver = webdriver.Chrome(driverpath)
    driver.get("https://workloads.cloudsdx.io/index.html")
    time.sleep(5)
