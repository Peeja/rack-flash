require File.dirname(__FILE__) + '/../../spec_helper'

describe Rack::Flash::FlashHash do
  it "should store and return objects like a hash" do
    fh = Rack::Flash::FlashHash.new
    fh[:foo] = 123
    
    fh[:foo].should == 123
  end
  
  it "should return stored objects consistently" do
    fh = Rack::Flash::FlashHash.new
    fh[:foo] = 123
    fh[:foo]
    
    fh[:foo].should == 123
  end
  
  describe "#sweep" do
    it "should remove objects which have been accessed" do
      fh = Rack::Flash::FlashHash.new
      fh[:foo] = 123
      fh[:foo]
      fh.sweep
      
      fh[:foo].should be_nil
    end
    
    it "should not remove objects which haven't been accessed" do
      fh = Rack::Flash::FlashHash.new
      fh[:foo] = 123
      fh.sweep
      
      fh[:foo].should == 123
    end
  end
end
