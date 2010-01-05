# Chi-Squared takes two events (the class and the term) and calculates
# whether the two events are dependent. If they are, then the occurance
# of the term makes the occurance of the class more or less likely

module FeatureSelection
  class ChiSquared < Base
   
    def rank_features
      # Returns:
      #=> {:class => {'term' => score, 'term' => score}}
      @results = {}
      
      classes.each do |klass|
        @results[klass] = {}
        
        terms.each do |term|
          answer = calculate_contribution(term, klass)
          @results[klass][term] = answer
        end #terms.each
      end #classes.each
      @results
    end
    
    private
    
    def calculate_contribution(term, klass)
      n_1_1 = n_1_1(term, klass)
      n_1_0 = n_1_0(term, klass)
      n_0_1 = n_0_1(term, klass)
      n_0_0 = n_0_0(term, klass)
      
      (n_1_1 + n_1_0 + n_0_1 + n_0_0) * ((n_1_1 * n_0_0 - n_1_0 * n_0_1) ** 2) /
        (n_1_1 + n_0_1) * (n_1_1 + n_1_0) * (n_1_0 + n_0_0) * (n_0_1 + n_0_0)
    end
    
  end
end