require 'mister_bin'

module MenuCommander
  class Command < MisterBin::Command
    help "Menu Commander"

    usage "menu [CONFIG --dry --loop]"
    usage "menu (-h|--help|--version)"

    option "-d --dry", "Dry run - do not execute the command at the end, just show it"
    option "-l --loop", "Reopen the menu after executing the selected command"
    option "--version", "Show version number"

    param "CONFIG", "The name of the menu config file without the .yml extension [default: menu]"

    example "menu --dry"
    example "menu production --loop"
    example "menu -ld"

    attr_reader :last_command

    def run
      verify_sanity
      say "#{menu.header}\n" if menu.header

      if args['--loop']
        run_looped_menu
      else
        run_menu
      end
    end

    def menu
      @menu ||= Menu.new menu_file
    end

  private

    def verify_sanity
      raise Exit, VERSION if args['--version'] 
      raise MenuNotFound.new(paths: menu_paths, config: config) unless menu_file
    end

    def run_looped_menu
      loop do
        run_menu
        say ""
        break if ENV['MENU_COMMANDER_ENV'] == 'test'
      end
    end

    def run_menu
      command = menu.call
      @last_command = command

      if args['--dry']
        say "$ !txtpur!#{command}".strip
      else
        system command
      end
    end

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
