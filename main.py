import time
import random
import mulelogin 
import mulepayment 
import muleregister 
import mulebrowse 
import requests
import urllib, json
from webdriver import web

# url for get the users.
url = "https://workloads.cloudsdx.io/customers"

# Users will register.
muleregister.UserRegister()

# users will login,browse,add to cart and place a order.
for login in range(1,6):
    mulelogin.LoginandBrowse()
    mulebrowse.LoginBrowseCart()
    mulepayment.shipping()

# Deleting the users once the load generaion is done.  
response = urllib.urlopen(url)
data = json.load(response)
for i in range(len(data['_embedded']['customer'])):
    customerID = data['_embedded']['customer'][i]['id']
    generatedURL = url + "/" + customerID
    response= requests.delete(generatedURL)
    print "Deleted UserID: " + data['_embedded']['customer'][i]['id']

web.driver.close()