import csv

mule='/home/pradeep/Desktop/pradeep/Automation/mule.csv'
#Getting the data of users from a csv file.
class users():
    with open(mule, "r") as f_input:
        csv_input = csv.DictReader(f_input)
        Id = []
        names = []
        first = []
        last = []
        email = []
        pwd = []
        card = []
        expire = []
        ccv = []
        house = []
        street = []
        city = []
        post = []
        country = []

        for row in csv_input:
            Id.append(row['id'])
            names.append(row['username'])
            first.append(row['Firstname'])
            last.append(row['Lastname'])
            email.append(row['EmailID'])
            pwd.append(row['Password'])
            card.append(row['CardNumber'])
            expire.append(row['Expires'])
            ccv.append(row['CCV'])
            house.append(row['HouseNumber'])
            street.append(row['StreetName'])
            city.append(row['City'])
            post.append(row['PostCode'])
            country.append(row['Country'])
