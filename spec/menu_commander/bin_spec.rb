require 'spec_helper'

describe 'bin/menu' do
  describe '--version' do
    it 'shows version' do
      expect(`bin/menu --version`).to eq "#{VERSION}\n"
    end
  end

  describe '--help' do
    it 'shows usage' do
      expect(`bin/menu --help`).to match_approval('cli/help')
    end
  end

  context 'when calling an invalid menu config' do
    after { ENV['MENU_PATH'] = nil }

    it 'shows a friendly error' do
      expect(`bin/menu nomenu 2>&1`).to match_approval('cli/nomenu')
    end

    context 'when MENU_PATH is set with one path' do
      it 'shows where it looked for the config' do
        ENV['MENU_PATH'] = '/some/imaginary/folder'
        expect(`bin/menu nomenu 2>&1`).to match_approval('cli/single-path')
      end
    end

    context 'when MENU_PATH is set with multiple paths' do
      it 'shows where it looked for the config' do
        ENV['MENU_PATH'] = '/some/imaginary/folder:/another/folder'
        expect(`bin/menu nomenu 2>&1`).to match_approval('cli/multi-paths')
      end
    end
  end
end
