require 'rubygems'
require 'guard/jasmine_phantomjs'

current_dir = File.expand_path(File.dirname(__FILE__))
Dir.glob("#{current_dir}/../lib/**/*.rb").each{|file| require file }

RSpec.configure do |config|
  
  config.color_enabled = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.before(:each) do
    ENV['GUARD_ENV'] = 'test'
    @project_path    = Pathname.new(File.expand_path('../../', __FILE__))

    Guard::UI.stub(:info)
    Guard::UI.stub(:debug)
    Guard::UI.stub(:error)
    Guard::UI.stub(:success)
    Guard::UI.stub(:warning)
    Guard::UI.stub(:notify)
  end

  config.after(:each) do
    ENV['GUARD_ENV'] = nil
  end
end


def delete_by_pattern(pattern)
  Dir.glob(pattern).each{|file| File.delete(file) if File.exist?(file) }
end
