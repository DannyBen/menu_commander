module MenuCommander
  class Error < StandardError; end
  class Interrupt < Interrupt; end
  class Exit < SystemExit; end
  
  class MenuNotFound < Error
    # :nocov: - covered by external process
    attr_reader :paths, :config

    def initialize(message = nil, paths: nil, config: nil)
      message ||= "Could not find menu configuration file"
      @paths, @config = paths, config
      super message
    end
    # :nocov:
  end
end