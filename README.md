# PoolFinder
A web app to help you find the closest Toronto public pool that is open.

## Stack
* Ruby (Data loader)
* JavaScript/ReactJS
* Firebase

## How To: Loading data
In order to run the data loader, you must install the firebase SDK and create
a service account for your project. Then, download the `key.json` associated
with and put it in the root directory of this project. Run the `run.sh` script
and it will load in all the data from `static_data` to firebase for easy
searching. In the future it will load it from the web directly.
