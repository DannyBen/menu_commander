require 'mister_bin'
require 'colsole'

module MenuCommander
  class Command < MisterBin::Command
    include Colsole

    help "Execute the menu"
    usage "menu [CONFIG --dry]"
    usage "menu (-h|--help)"
    option "-d --dry", "Dry run. Do not execute the command at the end, just show it."
    param "CONFIG", "The name of the menu config file without the .yml extension [default: menu]"

    def run
      raise MenuNotFound unless File.exist? menu_file

      if args['--dry']
        say "$ !txtpur!#{command}"
      else
        exec command
      end
    end

    def menu
      @menu ||= Menu.new menu_file
    end

    def command
      @command ||= menu.call
    end

  private

    def menu_file
      "#{config}.yml"
    end

    def config
      config = args['CONFIG'] || 'menu'
    end

  end
end