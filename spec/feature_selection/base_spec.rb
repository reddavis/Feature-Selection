require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Base" do
  
  describe "Temp Directory" do    
    it "should create pids and marshalled temp dir" do
      FileUtils.should_receive(:mkdir_p).with('hello/pids')
      FileUtils.should_receive(:mkdir_p).with('hello/marshalled')
    
      FeatureSelection::Base.new(data, :temp_dir => 'hello')
    end
  end
  
end
