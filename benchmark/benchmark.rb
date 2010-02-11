require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + '/../lib/feature_selection')
require 'benchmark'

spam = Array.new(10) {Array.new(1) {rand.to_s}}
ham = Array.new(10) {Array.new(1) {rand.to_s}}

data = {
  :spam => spam,
  :ham => ham
}

log = File.expand_path(File.dirname(__FILE__) + '/log.txt')
tmp_dir = File.expand_path(File.dirname(__FILE__) + '/tmp')

#Benchmark.bm do |x|
#  x.report do
    FeatureSelection::MutualInformation.new(data, :workers => 2, :log_to => log, :temp_dir => tmp_dir).rank_features
#  end
#end
