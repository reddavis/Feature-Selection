require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Frequency Based" do
  
  describe "Should count how many times is occurs in spam" do
    it "should return 3" do
      a = FeatureSelection::FrequencyBased.new(data, :temp_dir => temp_dir)
      a.rank_features[:spam]['is'].should == 3
    end
  end
    
end
