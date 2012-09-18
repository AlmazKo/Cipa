
$:.unshift(File.dirname(__FILE__))
require 'lib/app'

app = proc do |env|
  [
      200,          # Status code
      {             # Response headers
                    'Content-Type' => 'application/json; charset=UTF-8'
      },
      [App.new.call()]        # Response body
  ]
end

# You can install Rack middlewares
# to do some crazy stuff like logging,
# filtering, auth or build your own.
use Rack::CommonLogger

run app