
$:.unshift(File.dirname(__FILE__))
require "lib/controller"
require "lib/app"
require "lib/parser"

@controller = Controller.new



app = proc do |env|
  @controller.example_action
end

use Rack::CommonLogger

run app