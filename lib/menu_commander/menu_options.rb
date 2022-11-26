module MenuCommander
  class MenuOptions
    attr_reader :options

    def initialize(options)
      options ||= {}
      options.transform_keys!(&:to_sym)
      @options = default_options.merge options
    end

    def default_options
      @default_options ||= {
        auto_select:         true,
        echo:                false,
        echo_marker_success: '✓',
        echo_marker_error:   '✗',
        filter:              'auto',
        header:              false,
        page_size:           10,
        select_marker:       '⯈',
        submenu_marker:      ' ⯆',
        title_marker:        '▌', # ➤ ❚ ✚
      }
    end

    def method_missing(method, *_args, &_block)
      respond_to?(method) ? options[method] : super
    end

    def respond_to_missing?(method_name, include_private = false)
      options.has_key?(method_name) || super
    end
  end
end
