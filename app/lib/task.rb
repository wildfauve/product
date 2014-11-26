class Task
  
  def self.all
    @tasks = Origination.in_progress
  end
  
end