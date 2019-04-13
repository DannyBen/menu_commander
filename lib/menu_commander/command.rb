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
      config = args['CONFIG'] || 'menu'
      dry = args['--dry']
      menu = Menu.new "#{config}.yml"
      command = menu.call
      if dry
        say "$ !txtpur!#{command}"
      else
        exec command
      end
    end

  end
end