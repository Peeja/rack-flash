$: << 'lib'
require 'rack'
require 'rack/flash'

use Rack::Session::Cookie
use Rack::Flash

app = lambda do |env|
  case env["PATH_INFO"]
  when "/cause_error"
    env["rack.session"][:flash][:error] = "Something went wrong."
    [302, {"Content-type" => "text/html", "Location" => "/view_error"}, ""]
    
  when "/view_error"
    [200, {"Content-type" => "text/html"}, "Current Error: #{env["rack.session"][:flash][:error]}"]
    
  else
    message  = "Try going to <a href='/cause_error'>/cause_error</a> "
    message += "or <a href='/view_error'>/view_error</a>"
    [200, {"Content-type" => "text/html"}, message]
  end
end

run app
