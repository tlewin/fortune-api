require 'goliath'
require 'multi_json'

class App < Goliath::API
  include Goliath::Rack::Templates
  use Goliath::Rack::Params

  # Call BSD fortune in async fashion
  #
  # @param long [String] '0' = disallow long, '1' = force long, else = allow both
  # @param dirty [String] '0' = only clean ones, '1' = only dirty ones, else = only clean ones
  #
  # @return [String] fortune text
  def async_fortune(long = nil, dirty = nil)
    # build fortune cmd based on API request
    fortune_cmd = 'fortune '
    fortune_cmd << case long
      when '0'
        '-s'
      when '1'
        '-l'
      else
        ''
      end
    fortune_cmd << ' -o' if dirty == '1'

    # Fiber aware EM.system
    #  stop the code execution until fortune process returns the text
    #  @see https://github.com/igrigorik/em-synchrony
    EM::Synchrony.system(fortune_cmd).first
  end

  # get '/fortune(.:format)' do
  def response env
    if env[Goliath::Constants::REQUEST_PATH] =~ /^\/fortune(\.(?<format>\w+))?\/?$/ &&
      env[Goliath::Constants::REQUEST_METHOD] == 'GET'
      format = Regexp.last_match[:format]
    else
      return [404, {}, 'Not found']
    end
    
    fortune_text  = async_fortune(params['long'], params['dirty'])

    # Parse the Accept header to render properly
    # The API is not so clear how the content_type is determined, 
    # but making some tests with curl I could find the following logic:
    # NOTE: I prefer to work with format directly (@see https://twitter.com/josevalim/status/7928782685995009)
    if format =~ /^html?$/i # only explicit calls
      [200, {'Content-Type' => 'text/html'}, erb(:fortune, {layout: nil}, {fortune_text: fortune_text})]
    elsif format =~ /^json$/i || env['HTTP_ACCEPT'] == 'application/json'
      [200, {'Content-Type' => 'application/json'}, MultiJson.dump({text: fortune_text}, pretty: true)]
    else
      [200, {'Content-Type' => 'text/plain'}, fortune_text]
    end
  end
end