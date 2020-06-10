class StringIO
  def wait_readable(*)
    true
  end

  # ref: https://github.com/piotrmurach/tty-screen/issues/11
  def ioctl(*)
    80
  end
end

module SpecMixin
  def keyboard
    {
      enter: '',
      down: "\e[B",
      up: "\e[A",
      page_up: "\e[5~",
      home: "\e[1~",
    }
  end

  def stdin_send(*args)
    begin
      $stdin = StringIO.new
      until args.empty?
        arg = args.shift % keyboard
        $stdin.puts arg
      end
      $stdin.rewind
      yield
    ensure
      $stdin = STDIN
    end
  end

  def capture_output
    original_stdout = $stdout
    $stdout = StringIO.new
    begin
      yield
      $stdout.string
    ensure
      $stdout = original_stdout
    end
  end

  def interactive(*args, &block)
    if ENV['DEBUG'] == '2'
      # :nocov:
      interactive! *args, &block
      # :nocov:
    else
      capture_output { interactive! *args, &block }
    end
  end

  def interactive!(*args)
    if args.any?
      stdin_send(*args) { yield }
    else
      # :nocov:
      yield
      # :nocov:
    end
  end

end
