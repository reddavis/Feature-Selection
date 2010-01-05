# Mutual Information measures how the much information
# presence/absence of a term contributes to making the correct
# classification

# Equation - for every class and term
#
# P(U=e(t), C=e(c)) * log2( P(U=e(t), C=e(c)) / P(U=e(t)) * P(C=e(c)) )

# We represent each function in the form - n(t,c)
# n(1,1) = count documents that have term and belong to specified class
# n(0,1) = count documents that do not have term and belongs to specified class
# n(1,0) = count documents that have term but do not belong to specified class
# n(0,0) = count documents that do not contain term and do not belong to specfied class
# n = n(1,1) + n(0,1) + n(1,0) + n(0,0)

module FeatureSelection
  class MutualInformation < Base
        
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
      calculate_section(term, klass, 1, 1) +
        calculate_section(term, klass, 1, 0) +
          calculate_section(term, klass, 0, 1) +
            calculate_section(term, klass, 0, 0)
    end
    
    def calculate_section(term, klass, t, c)
      n = count_documents
      n_1_0 = n_1_0(term, klass)
      n_0_1 = n_0_1(term, klass)
      
      begin
        if t == 1 && c == 1
          n_1_1 = n_1_1(term, klass)
                    
          n_1_1 / n * 
            Math.log( (n * n_1_1) / ((n_0_1 + n_1_1) * (n_1_1 + n_1_0)) ) 
        elsif t == 1 && c == 0
          n_1_1 = n_1_1(term, klass)
          n_0_0 = n_0_0(term, klass)
        
          n_1_0 / n *
            Math.log( (n * n_1_0) / ((n_1_1 + n_0_1) * (n_0_1 + n_0_0)) )
        elsif t == 0 && c == 1
          n_0_0 = n_0_0(term, klass)
          n_1_1 = n_1_1(term, klass)
        
          n_0_1 / n *
            Math.log( (n * n_0_1) / ((n_1_0 + n_0_0) * (n_1_1 + n_1_0)) )
        elsif t == 0 && c == 0
          n_0_0 = n_0_0(term, klass)
        
          n_0_0 / n *
            Math.log( (n * n_0_0) / ((n_1_0 + n_0_0) * (n_0_1 + n_0_0)) )
        end
      rescue ZeroDivisionError, Errno::EDOM
        0.0
      end
    end
        
  end
end