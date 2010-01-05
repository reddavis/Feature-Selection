module FeatureSelection
  class Base
    
    def initialize(data)
      @data = data
    end
    
    def classes
      @classes ||= find_all_classes
    end
    
    private
    
    # Contains term and belongs to class
    def n_1_1(term, klass)
      count = 0.0
      
      @data[klass].each do |document|
        count += 1 if document.include?(term)
      end
      
      count
    end
    
    # Contains term but does not belong to class
    def n_1_0(term, klass)
      count = 0.0
      
      @data.each_pair do |key, documents|
        if key != klass
          documents.each do |document|
            count += 1 if document.include?(term)
          end
        end
      end
      
      count
    end
    
    # Does not contain term but belongs to class
    def n_0_1(term, klass)
      count = 0.0
      
      @data[klass].each do |document|
        count += 1 if !document.include?(term)
      end
      
      count
    end
    
    # Does not contain term and does not belong to class
    def n_0_0(term, klass)
      count = 0.0
      
      @data.each_pair do |key, documents|
        if key != klass
          documents.each do |document|
            count += 1 if !document.include?(term)
          end
        end #if key
      end #@data.each_pair
      
      count
    end
    
    # All of the counts added together
    def count_documents
      size = 0
      @data.each_value do |documents|
        size += documents.size
      end
      
      size
    end
    
    def find_all_classes
      @data.map {|x| x[0]}
    end
    
    def terms
      @data.map {|x| x[1]}.flatten
    end
  end
end