require File.dirname(__FILE__) + '/../spec_helper'

describe Rack::Flash do
  it "should put a FlashHash in the session" do
    app = mock("app")
    env = {"rack.session" => {}}
    f   = Rack::Flash.new(app)
    
    app.should_receive(:call) do |env|
      env["rack.session"][:flash].should be_an_instance_of(Rack::Flash::FlashHash)
    end
    
    f.call(env)
  end
  
  it "should not replace a FlashHash already in the session" do
    app   = mock("app")
    flash = Rack::Flash::FlashHash.new
    env   = {"rack.session" => {:flash => flash}}
    f     = Rack::Flash.new(app)
    
    call_count = 0
    
    app.should_receive(:call).twice do |env|
      if call_count == 0
        env["rack.session"][:flash][:error] = "Something went wrong."
      else
        env["rack.session"][:flash][:error].should == "Something went wrong."
      end
      call_count += 1
    end
    
    f.call(env)
    f.call(env)
  end
  
  it "should sweep the FlashHash after calling the app" do
    app   = mock("app")
    flash = Rack::Flash::FlashHash.new
    env   = {"rack.session" => {:flash => flash}}
    f     = Rack::Flash.new(app)
    
    call_count = 0
    
    app.should_receive(:call).exactly(3).times do |env|
      if call_count == 0
        env["rack.session"][:flash][:error] = "Something went wrong."
      elsif call_count == 1
        env["rack.session"][:flash][:error]  # Access the value
      else
        env["rack.session"][:flash][:error].should == nil
      end
      call_count += 1
    end
    
    f.call(env)
    f.call(env)
    f.call(env)
  end
end
