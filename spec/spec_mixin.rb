module SpecMixin
  def reset_tmp_dir
    if Dir.exist? tmp_dir
      Dir["#{tmp_dir}/**/*"].each { |file| File.delete file if File.file? file }
    else
      # :nocov:
      Dir.mkdir tmp_dir
      # :nocov:
    end
  end

  def tmp_dir
    File.expand_path 'tmp', __dir__
  end

  def keyboard
    {
      enter: '',
      down: "\e[B",
      up: "\e[A",
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
      yield
    end
  end

end
