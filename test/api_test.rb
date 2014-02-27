require 'test_helper'

class APITest < Test::Unit::TestCase
  include Goliath::TestHelper
  
  def setup
    @err = Proc.new { assert false, "API request failed" }
  end

  context 'API test' do
    should 'should return 404 code if path is the root' do
      with_api(App) do
        get_request({path: '/'}, @err) do |c|
          assert_equal c.response_header.status, 404
        end
      end
    end

    should 'should return 404 if request is a post' do
      with_api(App) do
        post_request({path: '/fortune'}, @err) do |c|
          assert_equal c.response_header.status, 404
        end
      end
    end

    should 'return JSON content-type if the format is set' do
      with_api(App) do
        get_request({path: '/fortune.json'}, @err) do |c|
          assert_equal c.response_header['Content-Type'], Rack::Mime.mime_type('.json')
        end
      end
    end

    should 'return HTML content-type if the format is set' do
      with_api(App) do
        get_request({path: '/fortune.html'}, @err) do |c|
          assert_equal c.response_header['Content-Type'], Rack::Mime.mime_type('.html')
        end
      end

      with_api(App) do
        get_request({path: '/fortune.htm'}, @err) do |c|
          assert_equal c.response_header['Content-Type'], Rack::Mime.mime_type('.htm')
        end
      end
    end

    should 'return JSON content-type if the accept header is set' do
      with_api(App) do
        get_request({path: '/fortune', head: {accept: 'application/json'}}, @err) do |c|
          assert_equal c.response_header['Content-Type'], Rack::Mime.mime_type('.json')
        end
      end
    end

    should 'return text content-type if nothing is set' do
      with_api(App) do
        get_request({path: '/fortune'}, @err) do |c|
          assert_equal c.response_header['Content-Type'], Rack::Mime.mime_type('.text')
        end
      end
    end

    should 'call fortune program without args if no URL variable is passed' do
      EM::Synchrony.expects(:system).with('fortune ').returns([';)'])
      with_api(App) do
        get_request({path: '/fortune'}, @err) {}
      end
    end

    should 'call fortune program with param -l with long=1 arg is passed' do
      EM::Synchrony.expects(:system).with('fortune -l').returns([';)'])
      with_api(App) do
        get_request({path: '/fortune?long=1'}, @err) {}
      end
    end

    should 'call fortune program with param -s with long=0 arg is passed' do
      EM::Synchrony.expects(:system).with('fortune -s').returns([';)'])
      with_api(App) do
        get_request({path: '/fortune?long=0'}, @err) {}
      end
    end

    should 'call fortune program with param -o with dirty=1 arg is passed' do
      EM::Synchrony.expects(:system).with('fortune  -o').returns([';)'])
      with_api(App) do
        get_request({path: '/fortune?dirty=1'}, @err) {}
      end
    end

    should 'call fortune program with no param with dirty=0 arg is passed' do
      EM::Synchrony.expects(:system).with('fortune ').returns([';)'])
      with_api(App) do
        get_request({path: '/fortune?dirty=0'}, @err) {}
      end
    end

    should 'call fortune program with param -l -o with long=1&dirty=1 arg is passed' do
      EM::Synchrony.expects(:system).with('fortune -l -o').returns([';)'])
      with_api(App) do
        get_request({path: '/fortune?long=1&dirty=1'}, @err) {}
      end
    end

    should 'call fortune program with param -s -o with long=0&dirty=1 arg is passed' do
      EM::Synchrony.expects(:system).with('fortune -s -o').returns([';)'])
      with_api(App) do
        get_request({path: '/fortune?long=0&dirty=1'}, @err) {}
      end
    end
  end
end
