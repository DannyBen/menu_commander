module MenuCommander
  class Error < StandardError; end
  
  class MenuNotFound < Error
    # :nocov: - covered by external process
    def initialize(message="Could not find menu configuration file")
      super
    end
    # :nocov:
  end
end