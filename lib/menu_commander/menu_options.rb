module MenuCommander
  class MenuOptions
    attr_reader :options

    def initialize(options)
      options ||= {}
      options.transform_keys! &:to_sym
      @options = default_options.merge options
    end    

    def default_options
      @default_options ||= {
        header: false,
        submenu_marker: " ⯆",
        select_marker: "⯈",
        title_marker: "◾",
        page_size: 10,
        filter: 'auto',
      }
    end

    def method_missing(method, *_args, &_block)
      respond_to?(method) ? options[method] : super
    end

    def respond_to_missing?(method_name, include_private=false)
      options.has_key?(method_name) || super
    end
  end
end