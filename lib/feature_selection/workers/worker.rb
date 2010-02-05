require 'rubygems'
require 'beanstalk-client'
require 'memcached'
require File.expand_path(File.dirname(__FILE__) + '/../job')

# Contains term and belongs to class
def n_1_1(term, documents)   
  count = 0.0
  
  documents.each do |document|
    count += 1 if document.include?(term)
  end

  count
end

# Contains term but does not belong to class
def n_1_0(term, documents)
  count = 0.0

  documents.each do |document|
    count += 1 if document.include?(term)
  end

  count
end

# Does not contain term but belongs to class
def n_0_1(term, documents)
  count = 0.0

  documents.each do |document|
    count += 1 if !document.include?(term)
  end
  
  count
end

# Does not contain term and does not belong to class
def n_0_0(term, documents)
  count = 0.0
  
  documents.each do |document|
    count += 1 if !document.include?(term)
  end

  count
end
  
# Connect to Beanstalk
connection = Beanstalk::Pool.new(['localhost:11300'])
connection.watch('main')

# Connect to Memcached
memcached = Memcached.new('localhost:11211')

marshalled_document_path = ARGV[0]

data = ""
File.open(marshalled_document_path) do |f|
  while line = f.gets
    data << line
  end
end
      
documents = Marshal.load(data)

loop do
  job = connection.reserve
  
  job_data = Marshal.load(job.body)
  
  memcached.increment('job_count')
  
  klass = job_data.klass
  term = job_data.term
  
  documents_belonging_to_klass = documents.clone.delete_if {|k,v| k != klass}.values[0]
  documents_not_belonging_to_klass = documents.clone.delete_if {|k,v| k == klass}.values[0]
  
  case job_data.calculation
  when :n_1_1
    count = n_1_1(job_data.term, documents_belonging_to_klass)
  when :n_1_0
    count = n_1_0(job_data.term, documents_not_belonging_to_klass)
  when :n_0_1
    count = n_0_1(job_data.term, documents_belonging_to_klass)
  when :n_0_0
    count = n_0_0(job_data.term, documents_not_belonging_to_klass)
  end
      
  memcached.set("#{job_data.term.gsub(/\s+/, '@')}_#{klass}_#{job_data.calculation}", count)

  job.delete
end