require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + '/../lib/feature_selection')
require 'benchmark'

data = {
:spam => [['this', 'is', 'some', 'yer', 'information'], ['this', 'is', 'something', 'that', 'is', 'information']],
:ham => [['this', 'test', 'some', 'more', 'information'], ['there', 'are', 'some', 'things']],
}

Benchmark.bm do |x|
  x.report do
    puts FeatureSelection::MutualInformation.new(data, :workers => 2).rank_features
  end
end
