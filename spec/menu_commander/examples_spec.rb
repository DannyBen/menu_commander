require 'spec_helper'
require 'yaml'

describe 'examples' do
  subject { CLI.router }

  it 'executes successfully' do
    tests = YAML.load_file('spec/menu_commander/examples.yml')[:tests]
    tests.each do |spec|
      dir = spec[:dir] || 'examples'

      Dir.chdir dir do
        command = spec[:cmd]
        keyboard = spec[:kbd] || []

        test_name = "#{command} (#{keyboard.join ' '})"
        test_name = 'no-arguments' if test_name.empty?

        say "$ m`menu #{test_name}`"

        fixture = test_name.gsub(/[^#\w\- (){}\[\]]/, '').strip

        allow_any_instance_of(Command).to receive(:system) do |obj|
          say "r`> stubbed`: #{obj.last_command}"
          obj.last_command != 'simulate-error'
        end

        argv = command.split
        output = interactive(*keyboard) do
          subject.run argv
        end
        expect(output).to match_approval "examples/#{fixture}"
      end
    end
  end
end
