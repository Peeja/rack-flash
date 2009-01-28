Rack::Flash
===========

A flash. For your Rack apps. `env["rack.session"][:flash]` looks like a hash.
Put something in it (like an error message), and you can get it later. Once
you've retrieved what you stored, it'll be cleared out at the end of the
session. So if in one request you

    env["rack.session"][:flash][:error] = "Email address is blank."

and in the next request (maybe caused by redirecting after the last one) you render

    - if env["rack.session"][:flash][:error]
      #error= env["rack.session"][:flash][:error]

(that's [Haml][1]) you'll see your error message in the second request. When the user's next
request comes, the message will be gone.

[1]: http://haml.hamptoncatlin.com/ "#haml"


Using Rack::Flash
-----------------

Rack::Flash is a Rack middleware. How you use it depends on how you run your
rack app. If you're running a **Rackup file**, just add the following somewhere
before your `run` command:

    require 'rack/flash'
    use Rack::Flash

**However**, Rack::Flash needs a session to work its magic, so make sure you use one before Rack::Flash.  Something like:

    require 'rack/flash'
    use Rack::Session::Cookie
    use Rack::Flash

(Rack comes with [a few session middlewares to choose from][2]; any of them
will work.) Your session key will have to be "rack.session". This might become
configurable one day.

If you're running **Sinatra**, you've already got a session for free. Add the
code above (the one without the session line) to your Sinatra file near the
top. Also, Sinatra gives you a helper to access the session, so for you, the
flash is as easy as

    session[:flash][:error] = "Email address is blank."
    # ...
    haml "#error= session[:flash][:error]"

[2]: http://rack.rubyforge.org/doc/classes/Rack/Session.html "Module: Rack::Session"


Full Example
------------

Here's a full Rackup file demonstrating Rack::Flash. It's also in the tree as
`examples/example.ru`. To run it, run `rackup examples/example.ru`.

When you go to `http://localhost:9292/` you'll see links to `/view_error` and
`/cause_error`. The former displays the current error stored in the flash. The
latter puts an error in the flash and redirects to `/view_error`. If you just
go to `/view_error`, you won't see an error. If you go via `/cause_error`
you'll see one, but the next time you go to `/view_error` the error message
will be gone. That's the magic of the Flash!

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
        message  = "Try going to <a href='/view_error'>/view_error</a> "
        message += "or <a href='/cause_error'>/cause_error</a>"
        [200, {"Content-type" => "text/html"}, message]
      end
    end

    run app


(This project is not affiliated in any way with FlashYourRack.com.)