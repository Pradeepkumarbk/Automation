import time 
from muledata import users
from webdriver import web

def UserRegister():
    i=0
    while i < len(users.Id) :
        #user registration
        web.driver.find_element_by_xpath("/html/body/div[1]/div/div[1]/div[2]/ul/li[2]/a").click()
        time.sleep(2)
        
        elem = web.driver.find_element_by_xpath("//*[@id='register-username-modal']")
        elem.send_keys(users.names[i])
        time.sleep(1)

        elem = web.driver.find_element_by_xpath("//*[@id='register-first-modal']")
        elem.send_keys(users.first[i])
        time.sleep(1)

        elem = web.driver.find_element_by_xpath("//*[@id='register-last-modal']")
        elem.send_keys(users.last[i])
        time.sleep(1)

        elem = web.driver.find_element_by_xpath("//*[@id='register-email-modal']")
        elem.send_keys(users.email[i])
        time.sleep(1)

        elem = web.driver.find_element_by_xpath("//*[@id='register-password-modal']")
        elem.send_keys(users.pwd[i])
        time.sleep(1)

        web.driver.find_element_by_xpath("//*[@id='register-modal']/div/div/div[2]/form/p/button").click()
        time.sleep(6)
        
        web.driver.find_element_by_xpath("//*[@id='basket-overview']/a/i").click()
        time.sleep(2)

        # Adding payment details.
        web.driver.find_element_by_xpath("//*[@id='add_payment']/a").click()
        time.sleep(1)
        elem = web.driver.find_element_by_xpath("//*[@id='form-card-number']")
        elem.send_keys(users.card[i])

        elem = web.driver.find_element_by_xpath("//*[@id='form-expires']")
        elem.send_keys(users.expire[i])

        elem = web.driver.find_element_by_xpath("//*[@id='form-ccv']")
        elem.send_keys(users.ccv[i])

        web.driver.find_element_by_xpath("//*[@id='card-modal']/div/div/div[2]/p/button").click()
        time.sleep(2)

        # Providing shipping details.
        web.driver.find_element_by_xpath("//*[@id='add_shipping']/a").click()
        time.sleep(1)

        elem = web.driver.find_element_by_xpath("//*[@id='form-number']")
        elem.send_keys(users.house[i])

        elem = web.driver.find_element_by_xpath("//*[@id='form-street']")
        elem.send_keys(users.street[i])

        elem = web.driver.find_element_by_xpath("//*[@id='form-city']")
        elem.send_keys(users.city[i])

        elem = web.driver.find_element_by_xpath("//*[@id='form-post-code']")
        elem.send_keys(users.post[i])

        elem = web.driver.find_element_by_xpath("//*[@id='form-country']")
        elem.send_keys(users.country[i])

        web.driver.find_element_by_xpath("//*[@id='form-address']/p/button").click()
        time.sleep(4)

        #logout
        web.driver.find_element_by_xpath("//*[@id='logout']/a").click()
        time.sleep(5)

        i = i+1
        
