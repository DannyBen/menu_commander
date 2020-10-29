require 'mister_bin'

module MenuCommander
  class CLI
    def self.router
      MisterBin::Runner.new handler: Command
    end
  end
end
