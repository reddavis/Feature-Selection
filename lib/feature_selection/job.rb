# A Job goes into the queue...
class Job
  
  attr_reader :term, :klass, :calculation
  
  def initialize(term, klass, calculation)
    @term = term
    @klass = klass
    @calculation = calculation
  end
  
end