require 'rubygems'
require 'daemons'

pids = ARGV[1]
worker = File.expand_path(File.dirname(__FILE__) + '/worker.rb')

Daemons.run(
            worker, 
            :dir_mode => :normal, 
            :dir => pids,
            :multiple => true
          )