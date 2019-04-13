require 'mister_bin'

module MenuCommander
  class CLI
    def self.router
      router = MisterBin::Runner.new version: VERSION,
        header: "CLI Menu Generator"

      router.route_all to: Command
      router
    end
  end
end
