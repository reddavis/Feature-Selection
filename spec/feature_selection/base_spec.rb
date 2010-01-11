require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Base" do
  
  before do
    @a = FeatureSelection::Base.new(data)
  end
  
  it "should include classes ham spam" do
    @a.classes.should include(:spam)
    @a.classes.should include(:ham)
  end
  
  describe "Logger" do
    before do
      # Remove test files
      Dir[File.expand_path(File.dirname(__FILE__) + "/../logger/*")].each do |file|
        FileUtils.rm(file)
      end
    end
    
    describe "New Logger" do
      before do
        @log_file = log_path
      end
      
      describe "Base" do
        it "should work create a log file called test_1.txt" do
          FeatureSelection::Base.new(data, :log_to => @log_file)
          File.exist?(@log_file).should be_true
        end
      end
      
      describe "MutualInformation" do
        it "should work and create a log file called test_1.txt" do
          FeatureSelection::MutualInformation.new(data, :log_to => @log_file).rank_features
          File.exist?(@log_file).should be_true
        end
      end
      
      describe "ChiSquared" do
        it "should work and create a log file called test_1.txt" do
          FeatureSelection::ChiSquared.new(data, :log_to => @log_file).rank_features
          File.exist?(@log_file).should be_true
        end
      end
      
      describe "FrequencyBased" do
        it "should work and create a log file called test_1.txt" do
          FeatureSelection::FrequencyBased.new(data, :log_to => @log_file).rank_features
          File.exist?(@log_file).should be_true
        end
      end
    end
    
    describe "Existing Log" do
      describe "FrequencyBased" do
        it "should work, therefore return a hash" do
          a = FeatureSelection::FrequencyBased.new(data, :log_to => @log_file)
          a.rank_features.should be_a(Hash)
        end
      end
      
      describe "MutualInformation" do
        it "should work, therefore return a hash" do
          a = FeatureSelection::MutualInformation.new(data, :log_to => @log_file)
          a.rank_features.should be_a(Hash)
        end
      end
      
      describe "ChiSquared" do
        it "should work, therefore return a hash" do
          a = FeatureSelection::ChiSquared.new(data, :log_to => @log_file)
          a.rank_features.should be_a(Hash)
        end
      end
    end
    
    def log_path
      File.expand_path(File.dirname(__FILE__) + "/../logger/test_1.txt")
    end
  end
      
end
