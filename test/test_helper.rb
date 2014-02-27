require 'goliath/test_helper'
require 'rack/mime'

require './app.rb'

require 'test/unit'
require 'shoulda'
require 'mocha/setup'


Goliath.env = :test