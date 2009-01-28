class Rack::Flash
  require 'rack/flash/flash_hash'
  
  def initialize(app)
    @app = app
  end

  def call(env)
    env["rack.session"][:flash] ||= FlashHash.new
    status, headers, body = @app.call(env)
    env["rack.session"][:flash].sweep
    
    [status, headers, body]
  end
end
