module FeatureSelection
  class FrequencyBased < Base
   
    def rank_features
      # Returns:
      #=> {:class => {'term' => count, 'term' => count}}
      @results = {}
      
      classes.each do |klass|
        @results[klass] = {}
        
        terms.each do |term|
          if @results[klass].key?(term)
            @results[klass][term] += 1
          else
            @results[klass][term] = 1
          end
        end #terms.each
      end #classes.each
      @results
    end
        
  end
end