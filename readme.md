[![Build Status](https://travis-ci.org/spree-contrib/spree_digital.png?branch=2-3-stable)](https://travis-ci.org/spree-contrib/spree_digital)

# Spree Digital

This is a spree extension to enable downloadable products (ebooks, MP3s, videos, etc).

The master branch is compatible with Spree 1.2.x. 1.0.x - 1.1.x versions are available, check the `Versionfile`.

This documentation is not complete and possibly out of date in some cases. There are features that have been implemented that are not documented here, please look at the source for complete documentation.

The idea is simple. You attach a file to a Product (or a Variant of this Product) and when people buy it, they will receive a link via email where they can download it once. There are a few assumptions that spree_digital (currently) makes and it's important to be aware of them. 

* The table structure of spree_core is not touched. Spree digital lives parallel to spree_core and does change the existing database, except adding two new tables.
* The download links will be sent via email in the order confirmation (or "resend" from the admin section). The links do *not* appear in the order "overview" that the customer sees. Adding download buttons to `OrdersController#show` is easy, [check out this gist](https://gist.github.com/3187793#file_add_spree_digital_buttons_to_invoice.rb).
* Once the order is checked-out, the download links will immediately be sent (i.e. in the order confirmation). You'll have to modify the system to support 'delayed' payments (like a billable account).
* You should create a ShippingMethod based on the Digital Delivery calculator type. The default cost for digital delivery is 0, but you can define a flat rate (creating a per-item digital delivery fee would be possible as well). Checkout the [source code](https://github.com/halo/spree_digital/blob/master/app/models/spree/calculator/digital_delivery.rb) for the Digital Delivery calculator for more information.
* One may buy several items of the same digital product in one cart. The customer will simply receive several links by doing so. This allows customer's to legally purchase multiple copies of the same product and maybe give one away to a friend.
* You can set how many times (clicks) the users downloads will work. You can also set how long the users links will work (expiration). For more information, [check out the preferences object](https://github.com/halo/spree_digital/blob/master/lib/spree/spree_digital_configuration.rb)
* The file `views/order_mailer/confirm_email.text.erb` is the only thing that should need customization. If you are looking for HTML emails, [this branch of spree-html-email](http://github.com/iloveitaly/spree-html-email) supports spree_digital
* A purchased product can be downloaded even if you disable the product immediately. You would have to remove the attached file in your admin section to prevent people from downloading purchased products.
* File are uploaded to `rails_root/private`. Make sure it's symlinked in case you're using Capistrano. If you want to change the upload path, [check out this gist](https://gist.github.com/3187793#file_spree_digital_path_change_decorator.rb)
* You must add a `views/spree/digitals/unauthorized.html.erb` file to customize an error message to the user if they exceed the download / days limit
* We use send_file to send the files on download. See below for instructions on how to push file downloading off to nginx.

## Installation

Add this line to your gemfile:

```shell
gem 'spree_digital', :git => 'git://github.com/halo/spree_digital.git', :branch => 'master'
```

The following terminal commands will copy the migration files to the corresponding directory in your Rails application and apply the migrations to your database.

```shell
bundle exec rails g spree_digital:install
bundle exec rake db:migrate
```

Then set any preferences.

### Shipping Configuration

You should create a ShippingMethod based on the Digital Delivery calculator type. It will be detected by `spree_digital`. Otherwise your customer will be forced to choose something like "UPS" even if they purchase only downloadable products.

### Improving File Downloading: `send_file` + nginx

Without customization, all file downloading will route through the rails stack. This means that if you have two workers, and two customers are downloading files, your server is maxed out and will be unresponsive until the downloads have finished.

Luckily there is an easy way around this: pass off file downloading to nginx (or apache, etc). Take a look at [this article](http://blog.kiskolabs.com/post/637725747/nginx-rails-send-file) for a good explanation.

```
# in your app's source
# config/environments/production.rb

# Specifies the header that your server uses for sending files
# config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx


# on your server
# /etc/nginx/sites-available/spree-secure
upstream unicorn_spree_secure {
  server unix:/data/spree/shared/sockets/unicorn.sock fail_timeout=0;
}

server {
  listen 443;
  ...

  location / {
    proxy_set_header X_FORWARDED_PROTO https;
    ... 

    proxy_set_header X-Sendfile-Type  X-Accel-Redirect;
    proxy_set_header X-Accel-Mapping  /data/spree/shared/uploaded-files/digitals/=/digitals/;
    
    ...
  }

  location /digitals/ {
    internal;
    root /data/spree/shared/uploaded-files/;
  }
  
  ...

}

```

References:

* [Gist of example config](https://gist.github.com/416004)
* [Change paperclip's upload / download path](https://gist.github.com/3187793#file_spree_digital_path_change_decorator.rb)
* ["X-Accel-Mapping header missing" in nginx error log](http://stackoverflow.com/questions/6237016/message-x-accel-mapping-header-missing-in-nginx-error-log)
* [Another good, but older, explanation](http://kovyrin.net/2006/11/01/nginx-x-accel-redirect-php-rails/)

## Usage

### Table Diagram

<img src="http://github.com/halo/spree_digital/raw/master/doc/tables.png">

### Installation

Get the spree framework and spree_digital extension for it:

```shell
git clone git://github.com/spree/spree.git
git clone git://github.com/halo/spree_digital.git
```

Go into the spree directory and run the bundle command:

```shell
cd spree
bundle install
```

Go into the spree_digital directory and do the same:

NOTE: At this point you may need to uncomment the stuff in the `Gemfile`  before you can start developing and testing!

```shell
cd spree_digital
bundle install
```

Bring up the test application (you only need to do this whenever you fiddle around with the migrations) and then you can run the tests as you please.

```shell
rake test_app
rake spec
```

This link may be very helpful to you: [http://github.com/spree/spree](http://github.com/spree/spree)

### Authors

* [iloveitaly](http://github.com/iloveitaly/)
* [halo](http://github.com/halo)

### License

Copyright (c) 2011 funkensturm.
Released under the MIT License
See [LICENSE](http://github.com/funkensturm/spree_digital/blob/master/LICENSE)
