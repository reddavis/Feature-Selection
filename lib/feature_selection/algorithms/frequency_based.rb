module FeatureSelection
  class FrequencyBased < Base
   
    def rank_features
      write_to_log("Starting to rank features...")
      # Returns:
      #=> {:class => {'term' => count, 'term' => count}}
      @results = {}
      
      # For logger
      total_calculations = classes.size * terms.size
      n = 1
      
      classes.each do |klass|
        @results[klass] = {}
        
        terms.each do |term|
          log_calculations_complete(n)
          n += 1
          
          if @results[klass].key?(term)
            @results[klass][term] += 1
          else
            @results[klass][term] = 1
          end
        end #terms.each
      end #classes.each
      @results
    end
    
    private
    
    # Overwrite Base#total_calculations
    def total_calculations
      classes.size * terms.size
    end
        
  end
end