require 'yaml'
require 'tty/prompt'

module MenuCommander
  class Menu
    attr_reader :config

    def initialize(config)
      config = YAML.load_file config if config.is_a? String
      @config = config
    end

    def call(menu = nil)
      menu ||= config['menu']
      response = select menu
      if response.is_a? String
        params = {}
        placeholders(response).each do |key|
          params[key.to_sym] = get_user_response key
        end

        response % params
      else
        call response
      end
    end

  private

    def placeholders(template)
      template.scan(/%{([^}]+)}/).flatten.uniq
    end

    def args
      config['args']
    end

    def get_user_response(key)
      opts = args ? args[key] : nil
      opts = opts.is_a?(String) ? `#{opts}`.split("\n") : opts

      if opts
        opts.size == 1 ? opts[0] : select(opts, key)
      else
        ask(key)
      end    
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end

    def ask(title)
      prompt.ask "> #{title}:"
    rescue TTY::Reader::InputInterrupt
      puts "\nGoodbye"
      exit
    end

    def select(options, title = nil)
      title = title ? "> #{title}:" : ">"
      menu_config = { marker: '>', per_page: 10 }
      menu_config['filter'] = true if options.size > 10
      prompt.select title, options, menu_config
    rescue TTY::Reader::InputInterrupt
      puts "\nGoodbye"
      exit
    end
  end
end