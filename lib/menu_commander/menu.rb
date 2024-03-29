require 'tty/prompt'
require 'extended_yaml'

module MenuCommander
  class Menu
    attr_reader :config

    def initialize(config)
      config = ExtendedYAML.load config if config.is_a? String
      @config = config
    end

    def call(menu = nil)
      menu ||= config['menu']
      response = select menu
      response = combine_commands response if response.is_a? Array

      history << menu

      response.is_a?(String) ? evaluate(response) : call(response)
    rescue MenuNavigation => e
      puts "\n\n"
      call e.menu
    end

    def options
      @options ||= MenuOptions.new(config['options'])
    end

  private

    def history
      @history ||= []
    end

    def combine_commands(command_array)
      if command_array.size == 1
        command_array.first
      else
        command_array.map { |cmd| "(#{cmd})" }.join ' && '
      end
    end

    def evaluate(response)
      params = {}
      placeholders(response).each do |key|
        params[key.to_sym] = get_user_response key
      end

      response % params
    end

    def placeholders(template)
      template.scan(/%{([^}]+)}/).flatten.uniq
    end

    def args
      config['args']
    end

    def get_user_response(key)
      opts = get_opts key
      opts_type = get_opts_type opts

      case opts_type
      when :free_text
        ask(key)
      when :static
        opts.first
      when :menu
        select(opts, key)
      end
    end

    def get_opts_type(opts)
      if !opts
        :free_text
      elsif options.auto_select && opts.is_a?(Array) && (opts.size == 1)
        :static
      else
        :menu
      end
    end

    def get_opts(key)
      opts = args ? args[key] : nil
      opts.is_a?(String) ? `#{opts}`.split("\n") : opts
    end

    def prompt
      @prompt ||= prompt!
    end

    def prompt!
      result = TTY::Prompt.new
      result.on(:keypress) { |event| handle_keypress event }
      result
    end

    def handle_keypress(event)
      case event.key.name
      when :page_up
        parent_menu = history.pop
        raise MenuNavigation, parent_menu if parent_menu

      when :home
        home_menu = history.first
        if home_menu
          @history = []
          raise MenuNavigation, home_menu
        end

      end
    end

    def ask(title)
      prompt.ask "> #{title}:"
    rescue TTY::Reader::InputInterrupt
      # :nocov:
      raise ExitMenu
      # :nocov:
    end

    def apply_suffix(choices)
      choices.to_h do |key, value|
        key = "#{key}#{options.submenu_marker}" if value.is_a? Hash
        [key, value]
      end
    end

    def enable_filter?(choices)
      case options.filter
      when true then true
      when false then false
      when Numeric then choices.size > options.filter
      else
        choices.size > options.page_size
      end
    end

    def select(choices, title = nil)
      title = title ? "#{options.title_marker} #{title}:" : options.title_marker
      choices = apply_suffix choices if options.submenu_marker && choices.is_a?(Hash)
      select! choices, title
    end

    def select!(choices, title)
      prompt.select title, choices,
        symbols:  { marker: options.select_marker },
        per_page: options.page_size,
        filter:   enable_filter?(choices)
    rescue TTY::Reader::InputInterrupt
      # :nocov:
      raise ExitMenu
      # :nocov:
    end
  end
end
