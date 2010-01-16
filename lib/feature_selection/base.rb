require 'beanstalk-client'
require 'memcached'
require 'FileUtils'

module FeatureSelection
  class Base
    include LogHelpers
    
    def initialize(data, options={})
      @data = data
      create_log(options[:log_to]) if options[:log_to]
    end
    
    def classes
      @classes ||= @data.map {|x| x[0]}
    end
    
    private
    
    ## Steps
    # Marshal the documents
    # Power up some workers
    # Create and push all jobs on the queue
    def pre_compute_counts
      # Marshal documents      
      save_marshalled_data
      
      # Start the workers
      start_workers(8)
      
      # Set which queue to use
      beanstalk.use('main')
      
      # Set jobs complete count
      memcache.set('job_count', 0, 0, nil)
      total_jobs = 0
      
      write_to_log("Adding jobs to the queue")
      uniq_terms.each do |term|
        jobs = []
        
        classes.each do |klass|
          # N11
          jobs << Job.new(term, klass, :n_1_1)
          # N10
          jobs << Job.new(term, klass, :n_1_0)
          # N01
          jobs << Job.new(term, klass, :n_0_1)
          # N00
          jobs << Job.new(term, klass, :n_0_0)
        end
        
        # Add the jobs to the queue
        jobs.each do |job| 
          total_jobs += 1
          beanstalk.put(Marshal.dump(job))
        end
      end
            
      # Wait until jobs are all complete
      until memcache.get('job_count', false).to_i == total_jobs
      end
      
      # Removed the marshalled documents
      FileUtils.rm(marshalled_document_path)
      # Stop all workers
      stop_workers
    end
    
    # Create a file with the marshalled @data so that the workers can
    # have access to it
    def save_marshalled_data
      File.open(marshalled_document_path, 'w+') do |file|
        file.write(Marshal.dump(@data))
      end
    end
    
    def marshalled_document_path
      File.expand_path(File.dirname(__FILE__) + '/documents')
    end
    
    def start_workers(n)
      n.times do
        system("ruby #{worker_daemon_path} start")
      end
    end
    
    def stop_workers
      system("ruby #{worker_daemon_path} stop")
    end
    
    # Where the workers are kept
    def worker_daemon_path
      File.expand_path(File.dirname(__FILE__) + '/workers/daemon.rb')
    end
    
    # Connect to Beanstalkd
    def beanstalk
      @beanstalk ||= Beanstalk::Pool.new(['localhost:11300'])
    end
    
    # Connect to Memcached
    def memcache
      @memcache ||= Memcached.new('localhost:11211')
    end
        
    # Contains term and belongs to class
    def n_1_1(term, klass)
      a = memcache.get("#{term}_#{klass}_n_1_1")
    end
        
    # Contains term but does not belong to class
    def n_1_0(term, klass)
      a = memcache.get("#{term}_#{klass}_n_1_0")
    end
        
    # Does not contain term but belongs to class
    def n_0_1(term, klass)
     a =  memcache.get("#{term}_#{klass}_n_0_1")
    end
        
    # Does not contain term and does not belong to class
    def n_0_0(term, klass)
      a = memcache.get("#{term}_#{klass}_n_0_0")
    end
  
    # All of the counts added together
    def count_documents
      size = 0
      @data.each_value do |documents|
        size += documents.size
      end
      
      size
    end
            
    def uniq_terms
      @uniq_terms ||= @data.map {|x| x[1]}.flatten.uniq
    end
    
    def terms
      @terms ||= @data.map {|x| x[1]}.flatten
    end
    
  end
end