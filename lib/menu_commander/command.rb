require 'mister_bin'

module MenuCommander
  class Command < MisterBin::Command
    help "Menu Commander"

    usage "menu [CONFIG --loop (--dry|--confirm)]"
    usage "menu (-h|--help|--version)"

    option "-d --dry", "Dry run - do not execute the command at the end, just show it"
    option "-l --loop", "Reopen the menu after executing the selected command"
    option "-c --confirm", "Show the command before execution and ask for confirmation"
    option "--version", "Show version number"

    param "CONFIG", "The name of the menu config file with or without the .yml extension [default: menu]"

    example "menu --dry"
    example "menu production --loop --confirm"
    example "menu -ld"

    attr_reader :last_command

    def run
      verify_sanity
      say "#{menu.options.header}\n" if menu.options.header

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
        break if ENV['MENU_COMMANDER_ENV'] == 'test'
        say ""
        @menu = nil
      end
    end

    def run_menu
      command = menu.call
      @last_command = command

      if args['--confirm']
        say "$ !txtpur!#{command}".strip
        system command if prompt.yes? "Execute?"
      elsif args['--dry']
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
        file = "#{dir}/#{config}"
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
      result = args['CONFIG'] || 'menu'
      result += ".yml" unless result.end_with?('.yml')
      result
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end
end
