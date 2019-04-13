require 'spec_helper'

describe 'bin/menu' do
  subject { CLI.router }

  context "on exception" do
    it "errors gracefuly" do
      expect(`bin/menu nomenu 2>&1`).to match_fixture('cli/exception')
    end
  end
end
