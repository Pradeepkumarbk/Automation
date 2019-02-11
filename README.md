# Automation for Mule-shop.

This is a sample project for automating things using selenium and provide the loadgen for Mule-shop. This automates the foloowing :-

- Registration of users.
- Pick a product.
- Add payment and shipping details.
- Place a order and logout.

## Steps 

Run the following on terminal.
### Install python

```
sudo apt update
sudo apt install python3.6
python3.6 --version
```
### Install selenium
```
pip3 install -U selenium
```

### Import selenium in python
```
python3.6
import selenium
selenium.__version__
This will show the selenium version installed.
```

Then in a new terminal run the script whenever the script is present on local setup directory with the following command 
`python3.6 socks.py`