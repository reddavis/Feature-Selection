require 'feature_selection/log_helpers'
require 'beanstalk-client'
require 'memcached'
require 'fileutils'

module FeatureSelection
  class Base
    include LogHelpers
    
    def initialize(data, options={})
      @data = data
      @no_of_workers = options[:workers] || 4
      @memcahed_sever = options[:memcached_server] || 'localhost:11211'
      
      create_log(options[:log_to]) if options[:log_to]
      create_temp_dirs(options[:temp_dir])
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
      write_to_log("Starting Workers")
      start_workers(@no_of_workers)
      
      # Set which queue to use
      beanstalk.use('main')
      
      # Set jobs complete count
      memcache.set('job_count', 0, 0, nil)
      total_jobs = 0
      
      write_to_log("Adding #{precalculated_jobs} jobs to the queue")   
      
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
        
        write_to_log("Placed #{total_jobs} / #{precalculated_jobs}")
      end
            
      # Wait until jobs are all complete
      until memcache.get('job_count', false).to_i == total_jobs
        write_to_log("#{memcache.get('job_count', false).to_i} / #{total_jobs}")
        sleep(2)
      end
    
      # Stop all workers
      stop_workers
      
      # Removed the marshalled documents
      FileUtils.rm(marshalled_document_path)
    end
    
    def precalculated_jobs
      uniq_terms.size * 2 * 4
    end
    
    # Create a file with the marshalled @data so that the workers can
    # have access to it
    def save_marshalled_data
      File.open(marshalled_document_path, 'w+') do |file|
        file.write(Marshal.dump(@data))
      end
    end
    
    # Path to the pids folder
    def pids_folder
      "#{@temp_dir}/pids"
    end
    
    # Path to marshalled folder
    def marshalled_folder
      "#{@temp_dir}/marshalled"
    end
    
    # Path to marshalled document
    def marshalled_document_path
      marshalled_folder + '/marshalled_documents'
    end
    
    def start_workers(n)
      n.times do
        system("ruby #{worker_daemon_path} start #{pids_folder} -- #{marshalled_document_path} #{@memcahed_sever}")
      end
    end
    
    def stop_workers
      system("ruby #{worker_daemon_path} stop #{pids_folder}")
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
      @memcache ||= Memcached.new(@memcahed_sever)
    end
        
    # Contains term and belongs to class
    def n_1_1(term, klass)
      memcache.get("#{term.gsub(/\s+/, '@')}_#{klass}_n_1_1")
    end
        
    # Contains term but does not belong to class
    def n_1_0(term, klass)
      memcache.get("#{term.gsub(/\s+/, '@')}_#{klass}_n_1_0")
    end
        
    # Does not contain term but belongs to class
    def n_0_1(term, klass)
      memcache.get("#{term.gsub(/\s+/, '@')}_#{klass}_n_0_1")
    end
        
    # Does not contain term and does not belong to class
    def n_0_0(term, klass)
      memcache.get("#{term.gsub(/\s+/, '@')}_#{klass}_n_0_0")
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
      @uniq_terms ||= @data.map {|x| x[1]}.flatten.uniq.freeze
    end
    
    def terms
      @terms ||= @data.map {|x| x[1]}.flatten.freeze
    end
    
    def create_temp_dirs(dir)
      if dir
        @temp_dir = dir
        # Create pid folder
        FileUtils.mkdir_p(pids_folder)
        # Create folder to hold marshalled data
        FileUtils.mkdir_p(marshalled_folder)
      else
        raise "You need to specify a path for the temporary files (:temp_dir => 'here')"
      end
    end
        
  end
end