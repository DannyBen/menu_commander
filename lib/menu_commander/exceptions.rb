module MenuCommander
  class Error < StandardError; end
  
  class MenuNotFound < Error
    def initialize(message="Could not find menu configuration file")
      super
    end
  end
end