import time
import random
from selenium import webdriver


user = ("Atul", "Abhisek", "Ajesh", "chandan")
firsst = ("John", "Nick", "Joe", "Arnold")
second = ("Rock", "Mike")

for x in range(2,4):

    usr = random.choice(user)
    first = random.choice(firsst)
    last = random.choice(second)
    mail = "befjbei@gmail.com"

    driverpath = "/usr/bin/chromedriver"
    driver = webdriver.Chrome(driverpath)
    driver.get("http://147.75.102.37:30001/index.html")
    time.sleep(5)

    # Registering a user  by providing the required details i.e Username,first name,last name, email-id and password.
    driver.find_element_by_xpath("/html/body/div[1]/div/div[1]/div[2]/ul/li[2]/a").click()
    time.sleep(2)
    
    elem = driver.find_element_by_xpath("//*[@id='register-username-modal']")
    elem.send_keys(usr)
    time.sleep(1)

    elem = driver.find_element_by_xpath("//*[@id='register-first-modal']")
    elem.send_keys(first)
    time.sleep(1)

    elem = driver.find_element_by_xpath("//*[@id='register-last-modal']")
    elem.send_keys(last)
    time.sleep(1)

    elem = driver.find_element_by_xpath("//*[@id='register-email-modal']")
    elem.send_keys(mail)
    time.sleep(1)

    elem = driver.find_element_by_xpath("//*[@id='register-password-modal']")
    elem.send_keys("1234vklfv")
    time.sleep(1)

    driver.find_element_by_xpath("//*[@id='register-modal']/div/div/div[2]/form/p/button").click()
    time.sleep(5)

    # Clicking on the catagory section.
    driver.find_element_by_xpath("//*[@id='tabCatalogue']/a").click()
    time.sleep(2)

    # Filtering out via colour.
    driver.find_element_by_xpath("//*[@id='filters']/div[1]/label/input").click()
    driver.find_element_by_xpath("//*[@id='filters-form']/a").click()
    time.sleep(5)
    
    # Selecting the item and adding it to cart.
    driver.find_element_by_xpath("//*[@id='products']/div[1]/div/div[2]/p[2]/a[2]").click()
    time.sleep(10)

    driver.find_element_by_xpath("//*[@id='numItemsInCart']").click()
    time.sleep(2)

    # Adding payment details.
    driver.find_element_by_xpath("//*[@id='add_payment']/a").click()
    time.sleep(1)
    elem = driver.find_element_by_xpath("//*[@id='form-card-number']")
    elem.send_keys("1234456767897234")

    elem = driver.find_element_by_xpath("//*[@id='form-expires']")
    elem.send_keys("02/20")

    elem = driver.find_element_by_xpath("//*[@id='form-ccv']")
    elem.send_keys("123")

    driver.find_element_by_xpath("//*[@id='card-modal']/div/div/div[2]/p/button").click()
    time.sleep(2)

    # Providing shipping details.
    driver.find_element_by_xpath("//*[@id='add_shipping']/a").click()
    time.sleep(1)

    elem = driver.find_element_by_xpath("//*[@id='form-number']")
    elem.send_keys("12")

    elem = driver.find_element_by_xpath("//*[@id='form-street']")
    elem.send_keys("hsr")

    elem = driver.find_element_by_xpath("//*[@id='form-city']")
    elem.send_keys("bengaluru")

    elem = driver.find_element_by_xpath("//*[@id='form-post-code']")
    elem.send_keys("560077")

    elem = driver.find_element_by_xpath("//*[@id='form-country']")
    elem.send_keys("India")

    driver.find_element_by_xpath("//*[@id='form-address']/p/button").click()
    time.sleep(2)

    # Placing the order.
    driver.find_element_by_xpath("//*[@id='orderButton']").click()
    time.sleep(2)

    # View the order details.
    driver.find_element_by_xpath("//*[@id='tableOrders']/tr/td[4]/a").click()
    time.sleep(2)

    # Logout once done.
    driver.find_element_by_xpath("//*[@id='logout']/a").click()
    time.sleep(5)

driver.close()
