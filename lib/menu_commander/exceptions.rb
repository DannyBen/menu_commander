module MenuCommander
  class Error < StandardError; end
  class Interrupt < Interrupt; end
  class Exit < SystemExit; end
  
  class MenuNotFound < Error
    # :nocov: - covered by external process
    attr_reader :paths, :config

    def initialize(message=nil, paths: nil, config: nil)
      message ||= "Could not find menu configuration file"
      @paths, @config = paths, config
      super message
    end
    # :nocov:
  end

  class ExitMenu < Interrupt
    # :nocov:
    def initialize(message=nil)
      super (message || "Goodbye")
    end
    # :nocov:
  end

  class MenuNavigation < StandardError
    attr_reader :menu

    def initialize(menu)
      @menu = menu
    end
  end
end