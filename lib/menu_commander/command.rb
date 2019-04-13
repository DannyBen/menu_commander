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
      raise MenuNotFound.new(paths: menu_paths, config: config) unless menu_file

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
      @menu_file ||= menu_file!
    end

    def menu_file!
      menu_paths.each do |dir|
        file = "#{dir}/#{config}.yml"
        return file if File.exist? file
      end
      nil
    end

    def menu_paths
      menu_env_path.split File::PATH_SEPARATOR
    end

    def menu_env_path
      ENV['MENU_PATH'] || '.'
    end

    def config
      config = args['CONFIG'] || 'menu'
    end
  end
end
