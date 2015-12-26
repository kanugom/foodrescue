## Hello! This is a replication of the FoodRescue project for Ventura County, CA with some tweaks. Currently, this app serves as a one-stop-shop to locate the Food Shelves/Pantries in and around the county. As and when details on composting is available, the app will be updated. 


Live at https://find-a-food-shelf.herokuapp.com/

This is on an MIT license

This application provides a resource for individuals and organizations to donate food to the needy in and around the county.


## Developer Setup

### Install ruby and rails

ubuntu:

```shell
sudo apt-get install autoconf automake bison build-essential curl git-core libapr1 libaprutil1 libc6-dev libltdl-dev libreadline6 libreadline6-dev libsqlite3-0 libsqlite3-dev libssl-dev libtool libxml2-dev libxslt-dev libxslt1-dev libyaml-dev ncurses-dev openssl sqlite3 zlib1g zlib1g-dev
curl -L get.rvm.io | bash -s stable
rvm install 2.1
rvm use 2.1
gem install rails
```

### run the app

```shell
cd foodrescue
bundle install
rails s
```

then `open http://localhost:3000`

### Deploy

Before deploying, you have to install the heroku toolbelt and add the heroku remote to the repo.

```shell
heroku git:remote -a food-rescue
```

To deploy changes:

```shell
git push heroku master
```

## Misc

* https://github.com/kristianmandrup/geo_point
* http://www.unitedstateszipcodes.org/zip-code-database/
* [Survey Decision Tree Diagram](docs/survey-decision-tree.pdf)
