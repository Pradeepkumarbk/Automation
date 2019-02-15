import time
import random
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import os

class web():
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument('--no-sandbox')
    driverpath = os.path.realpath("/usr/bin/chromedriver")
    driver = webdriver.Chrome(chrome_options=chrome_options, executable_path=driverpath)
    driver.get("https://workloads.cloudsdx.io/index.html")
    time.sleep(5)
