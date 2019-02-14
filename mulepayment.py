import time 
from webdriver import web
from muledata import users

def shipping():
    i=0
    while i < len(users.Id) :
        # user login
        web.driver.find_element_by_xpath("//*[@id='login']/a").click()
        time.sleep(2)

        elem = web.driver.find_element_by_xpath("//*[@id='username-modal']")
        elem.send_keys(users.names[i])
        time.sleep(2)

        elem = web.driver.find_element_by_xpath("//*[@id='password-modal']")
        elem.send_keys(users.pwd[i])
        time.sleep(2)
        
        web.driver.find_element_by_xpath("//*[@id='login-modal']/div/div/div[2]/form/p/button").click()
        time.sleep(5)

        #Clicking on the catagory section.
        web.driver.find_element_by_xpath("//*[@id='tabCatalogue']/a").click()
        time.sleep(2)

        # Filtering out via colour.
        web.driver.find_element_by_xpath("//*[@id='filters']/div[5]/label").click()
        web.driver.find_element_by_xpath("//*[@id='filters-form']/a").click()
        time.sleep(5)

        # Selecting the item and adding it to cart.
        web.driver.find_element_by_xpath("//*[@id='products']/div[1]/div/div[1]/div/div[1]/a/img").click()
        time.sleep(5)

        web.driver.find_element_by_xpath("//*[@id='buttonCart']").click()
        time.sleep(6)

        web.driver.find_element_by_xpath("//*[@id='basket-overview']/a/i").click()
        time.sleep(2)
        
        # Placing the order.
        web.driver.find_element_by_xpath("//*[@id='orderButton']").click()
        time.sleep(2)

        # View the order details.
        web.driver.find_element_by_xpath("//*[@id='tableOrders']/tr/td[4]/a").click()
        time.sleep(2)

        web.driver.find_element_by_xpath("//*[@id='logout']/a").click()
        time.sleep(5)
        i = i + 1