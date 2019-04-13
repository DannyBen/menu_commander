require 'spec_helper'

describe 'bin/menu_commander-handler' do
  subject { CLI.router }

  context "without arguments" do
    it "shows short usage" do
      expect{ subject.run %w[handler]}.to output_fixture('cli/handler/usage')
    end
  end

  context "with --help" do
    it "shows long usage" do
      expect{ subject.run %w[handler --help] }.to output_fixture('cli/handler/help')
    end
  end

  context "with required arguments" do
    # Implement
  end
end
