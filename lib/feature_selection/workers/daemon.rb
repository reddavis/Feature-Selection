require 'daemons'

pids = File.expand_path(File.dirname(__FILE__) + '/pids/')
worker = File.expand_path(File.dirname(__FILE__) + '/worker.rb')

Daemons.run(
            worker, 
            :dir_mode => :normal, 
            :dir => pids,
            :multiple => true
          )