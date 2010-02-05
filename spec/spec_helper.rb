$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'feature_selection'
require 'spec'
require 'spec/autorun'

def data
  {
  :spam => [['this', 'is', 'some', 'yer', 'information'], ['this', 'is', 'something', 'that', 'is', 'information']],
  :ham => [['this', 'test', 'some', 'more', 'information'], ['there', 'are', 'some', 'things']],
  }
end

def with_memcached
  fork { system("memcached") }  
  yield
  system('killall memcached')  # Kills both the ruby an memcached process
end

def with_beanstalkd
  fork { system("beanstalkd") }
  yield
  system('killall beanstalkd')  # Kills both the ruby an beanstalkd process
end

def with_beanstalkd_and_memcached
  fork { system("memcached") }
  fork { system("beanstalkd") }
  yield
  system('killall beanstalkd')
  system('killall memcached')
end

def temp_marshalled_file
  File.expand_path(File.dirname(__FILE__) + '/test_pids/marshalled/marshalled_documents')
end

def temp_dir
  File.expand_path(File.dirname(__FILE__) + '/test_pids')
end

Spec::Runner.configure do |config|
  
end
