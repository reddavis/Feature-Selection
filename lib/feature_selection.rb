require 'benchmark'
require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + '/feature_selection/log_helpers')
require File.expand_path(File.dirname(__FILE__) + '/feature_selection/base')
require File.expand_path(File.dirname(__FILE__) + '/feature_selection/job')
require File.expand_path(File.dirname(__FILE__) + '/feature_selection/algorithms/mutual_information')
require File.expand_path(File.dirname(__FILE__) + '/feature_selection/algorithms/chi_squared')
require File.expand_path(File.dirname(__FILE__) + '/feature_selection/algorithms/frequency_based')

#data = {
#      :spam => [['this', 'is', 'some', 'yer', 'information'], ['this', 'is', 'something', 'that', 'is', 'information']],
#      :ham => [['this', 'test', 'some', 'more', 'information'], ['there', 'are', 'some', 'things']],
#      }

data = {:ham => [], :spam => []}

5000.times do
  a = rand(999).to_s
  
  data[:ham] << [a] * 5
  data[:spam] << [a] * 5
end

Benchmark.bm do |x|
  x.report do
    FeatureSelection::MutualInformation.new(data).rank_features
  end
end
