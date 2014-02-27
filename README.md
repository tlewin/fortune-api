
# Fortune API

Simple web wrapper for fortune BSD program.

## Helmet

For this application, it was used the [Helmet Framework](https://github.com/tlewin/helmet). A small web framework, developed by myself, that runs on top of Goliath web server and provide a Sinatra like API.

The async approach for this kind of application has the benefit of still serving other requests, while the fortune process is running in background. In other words, the application can handle more than one request at time.

Using the `ab -c 10 -n 1000 http://localhost:9000/fortune` command to compare the async vs sync approach, we have the following numbers:

    async: 359.33 requests/sec (mean)
     sync: 257.78 requests/sec (mean)

_* iMac 2.9GHz Intel Core i5/ Ruby 2.0.0_

Almost 40% of performance gain!

## API documentation

The API returns the fortune text in three different formats:

1. `text/plain`: http://hostname:port/fortune
2. `application/json`: http://hostname:port/fortune.json
3. `text/html`: http://hostname:port/fortune.html (Simple web interface)

The application also recognizes the HTTP `Accept` header in order to determine the proper format.

It is possible to filter content by passing the following URL variables:

* `long`: 0 = disallow long, 1 = force long, null value indicates allow but do not force (Optional)
* `dirty`: 0 = only clean ones, 1 = only dirty ones, null value defaults to only clean ones (Optional)

## Usage

To start the application, just type the following command:

    ruby app.rb -s

The application should start at localhost:9000

For more options:

    ruby app.rb --help

## Tests

For tests:

    rake test

## Requirements

This code was tested using Ruby 2.0 and Ruby 2.1

## External dependencies

BSD fortune program

To install it on Mac OS X you can visit the link: http://download.cnet.com/fortune/3000-20416_4-8558.html

Or, if you are a brew user:

    brew install fortune

## Dependencies

All ruby dependencies are available in rubygems.org repository

* helmet [https://github.com/tlewin/helmet]
* multi_json [https://github.com/intridea/multi_json]

Tests

* shoulda [https://github.com/thoughtbot/shoulda]
* mocha [https://github.com/freerange/mocha]
* em-http-request [https://github.com/igrigorik/em-http-request]
