$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'feature_selection/base'
require 'feature_selection/job'
require 'feature_selection/algorithms/mutual_information'
require 'feature_selection/algorithms/chi_squared'
require 'feature_selection/algorithms/frequency_based'