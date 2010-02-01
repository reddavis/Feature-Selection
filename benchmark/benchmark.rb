require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + '/../lib/feature_selection')
require 'benchmark'

spam = Array.new(100) {Array.new(100) {rand.to_s}}
ham = Array.new(100) {Array.new(100) {rand.to_s}}

data = {
:spam => spam,
:ham => ham
}

log = File.expand_path(File.dirname(__FILE__) + '/log.txt')

Benchmark.bm do |x|
  x.report do
    puts FeatureSelection::MutualInformation.new(data, :workers => 2, :log_to => log).rank_features
  end
end
