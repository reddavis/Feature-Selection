require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Mutual Information" do
  
  it "should give this a score of 0.4904..." do
    a = FeatureSelection::MutualInformation.new(data, :temp_dir => temp_dir)
    a.rank_features[:spam]['this'].to_s.should match(/0.4904/)
  end
    
end
