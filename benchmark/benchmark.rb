require File.expand_path(File.dirname(__FILE__) + '/../lib/feature_selection')
require 'benchmark'

data = {:ham => [], :spam => []}

1000.times do
  a = rand(999).to_s
  
  data[:ham] << [a] * 5
  data[:spam] << [a] * 5
end

Benchmark.bm do |x|
  x.report do
    FeatureSelection::MutualInformation.new(data).rank_features
  end
end
