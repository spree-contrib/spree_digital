[![Compatibility](https://img.shields.io/badge/spree%20compatibility-3.0-pink.svg)](https://github.com/spree-contrib/spree_digital/blob/master/Versionfile)
[![Build Status](https://travis-ci.org/spree-contrib/spree_digital.png?branch=master)](https://travis-ci.org/spree-contrib/spree_digital)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://github.com/spree-contrib/spree_digital/blob/master/LICENSE.md)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/spree-contrib/spree_digital)

# Spree Digital

This is a spree extension to enable downloadable products (ebooks, MP3s, videos, etc).

In the [Versionfile](https://github.com/spree-contrib/spree_digital/blob/master/Versionfile) you can see which
[spree_digital branch](https://github.com/spree-contrib/spree_digital/branches/all?query=stable) supports which
[Spree version](https://github.com/spree/spree/branches/all?query=stable).
The master branch is not considered stable and corresponds to the [spree master branch](https://github.com/spree/spree).

This documentation is not complete and possibly out of date in some cases.
There are features that have been implemented that are not documented here, please look at the source for complete documentation.

The idea is simple.
You attach a file to a Product (or a Variant of this Product) and when people buy it, they will receive a link via email where they can download it once.
There are a few assumptions that spree_digital (currently) makes and it's important to be aware of them.

* The table structure of spree_core is not touched.
  Spree digital lives parallel to spree_core and does change the existing database, except adding two new tables.
* The download links will be sent via email in the order confirmation (or "resend" from the admin section).
  The links do *not* appear in the order "overview" that the customer sees.
  Adding download buttons to `OrdersController#show` is easy, [check out this gist](https://gist.github.com/3187793#file_add_spree_digital_buttons_to_invoice.rb).
* Once the order is checked-out, the download links will immediately be sent (i.e. in the order confirmation).
  You'll have to modify the system to support 'delayed' payments (like a billable account).
* You should create a ShippingMethod based on the Digital Delivery calculator type.
  The default cost for digital delivery is 0, but you can define a flat rate (creating a per-item digital delivery fee would be possible as well).
  Checkout the [source code](https://github.com/halo/spree_digital/blob/master/app/models/spree/calculator/digital_delivery.rb) for the Digital Delivery calculator for more information.
* One may buy several items of the same digital product in one cart.
  The customer will simply receive several links by doing so.
  This allows customer's to legally purchase multiple copies of the same product and maybe give one away to a friend.
* You can set how many times (clicks) the users downloads will work.
  You can also set how long the users links will work (expiration).
  For more information, [check out the preferences object](https://github.com/halo/spree_digital/blob/master/lib/spree/spree_digital_configuration.rb)
* The file `views/order_mailer/confirm_email.text.erb` needs to be customized by you.
  If you are looking for HTML emails, [this branch of spree-html-email](http://github.com/iloveitaly/spree-html-email) supports spree_digital.
* A purchased product can be downloaded even if you disable the product immediately.
  You would have to remove the attached file in your admin section to prevent people from downloading purchased products.
* File are uploaded to `RAILS_ROOT/private`.
  Make sure it's symlinked in case you're using Capistrano.
  If you want to change the upload path, [check out this gist](https://gist.github.com/3187793#file_spree_digital_path_change_decorator.rb).
* You must add a `views/spree/digitals/unauthorized.html.erb` file to customize an error message to the user if they exceed the download / days limit
* We use send_file to send the files on download.
  See below for instructions on how to push file downloading off to nginx.

## Installation

1. Add this extension to your Gemfile with this line:

  #### Spree >= 3.1

  ```ruby
  gem 'spree_digital', github: 'spree-contrib/spree_digital'
  ```

  #### Spree 3.0 and Spree 2.x

  ```ruby
  gem 'spree_digital', github: 'spree-contrib/spree_digital', branch: 'X-X-stable'
  ```

  The `branch` option is important: it must match the version of Spree you're using.
  For example, use `3-0-stable` if you're using Spree `3-0-stable` or any `3.0.x` version.

2. Install the gem using Bundler:
  ```ruby
  bundle install
  ```

3. Copy & run migrations
  ```ruby
  bundle exec rails g spree_digital:install
  ```

4. Restart your server

  If your server was running, restart it so that it can find the assets properly.

Then set any preferences in the web interface.

### Shipping Configuration

You should create a ShippingMethod based on the Digital Delivery calculator type.
It will be detected by `spree_digital`.
Otherwise your customer will be forced to choose something like "UPS" even if they purchase only downloadable products.

### Improving File Downloading: `send_file` + nginx

Without customization, all file downloading will route through the rails stack.
This means that if you have two workers, and two customers are downloading files, your server is maxed out and will be unresponsive until the downloads have finished.

Luckily there is an easy way around this:
pass off file downloading to nginx (or apache, etc).
Take a look at [this article](http://blog.kiskolabs.com/post/637725747/nginx-rails-send-file) for a good explanation.

```ruby
# in your app's source
# config/environments/production.rb

# Specifies the header that your server uses for sending files
# config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx
```

```nginx
# on your server
# e.g. /etc/nginx/sites-available/spree-secure
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

### Development

#### Table Diagram

<img src="https://cdn.rawgit.com/halo/spree_digital/master/doc/tables.png">

#### Testing

```shell
rake test_app
rake rspec
```

### Contributors

See https://github.com/halo/spree_digital/graphs/contributors

### License

MIT © 2011-2015 halo, see [LICENSE](http://github.com/halo/spree_digital/blob/master/LICENSE.md)
