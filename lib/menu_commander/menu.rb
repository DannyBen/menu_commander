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
      response = response.join ' && ' if response.is_a? Array
      
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
      opts = get_opts key
      opts ? select(opts, key) : ask(key)
    end

    def get_opts(key)
      opts = args ? args[key] : nil
      opts.is_a?(String) ? `#{opts}`.split("\n") : opts
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end

    def ask(title)
      prompt.ask "> #{title}:"

    rescue TTY::Reader::InputInterrupt
      # :nocov:
      raise Interrupt, "Goodbye"
      # :nocov:

    end

    def select(options, title = nil)
      title = title ? "> #{title}:" : ">"
      prompt.select title, options, marker: '>', per_page: 10, filter: true

    rescue TTY::Reader::InputInterrupt
      # :nocov:
      raise Interrupt, "Goodbye"
      # :nocov:

    end
  end
end