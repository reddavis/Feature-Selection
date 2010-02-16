module Paths
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
end