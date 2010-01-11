require 'logger'

module LogHelpers
  # 2 outcomes
  # - Filepath given: create a log to that file
  # - Logger object given: write to that object
  def create_log(log_to)
    if log_to.is_a?(Logger)
      @log = log_to
    else
      @log = Logger.new(log_to)
    end
  end
  
  def write_to_log(message)
    if @log
      @log.info(message)
    end
  end
  
  # Writes the number of calculations completed to the log
  def log_calculations_complete(n)
    write_to_log("#{n}/#{total_calculations} calculations complete.")
  end
end