$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'feature_selection'
require 'spec'
require 'spec/autorun'

def data
  {
  :spam => [['this', 'is', 'some', 'information'], ['this', 'is', 'something', 'that', 'is', 'information']],
  :ham => [['this', 'test', 'some', 'more', 'information'], ['there', 'are', 'some', 'things']],
  }
end

Spec::Runner.configure do |config|
  
end
