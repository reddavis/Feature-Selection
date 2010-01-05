require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Frequency Based" do
  
  before do
    @a = FeatureSelection::FrequencyBased.new(data)
  end
  
  it "should return an hash" do
    @a.rank_features.should be_a(Hash)
  end
  
  describe "Should count how many times is occurs in spam" do
    it "should return 3" do
      @a.rank_features[:spam]['is'].should == 3
    end
  end
    
end
