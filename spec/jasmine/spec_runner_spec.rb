# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

describe Jasmine::SpecRunner do
  describe "#generate_spec_runner_html" do
    let(:config){
      {
        src_dir: 'spec/data/src',
        spec_dir: 'spec/data/spec',
        jasmine_version: '1.3.1'
      }
    }
    let(:spec_runner){ Jasmine::SpecRunner.new(config) }
    let(:targets) { ['spec/data/spec/hoge.ts', 'spec/data/spec/foo.js'] }
    let(:dest_spec_runner) { "#{config[:spec_dir]}/SpecRunner.html" }
    let(:lib_dir) { "#{config.spec_dir}/lib" }

    after do
      delete_by_pattern(dest_spec_runner)
      FileUtils.remove_dir(lib_dir, true) if Dir.exist?(lib_dir)
    end

    it "指定したspecを実行するSpecRunner.htmlを生成する" do
      spec_runner.generate_spec_runner_html(targets)
      expect(File.exist?(dest_spec_runner)).to be_true
      result = File.read(dest_spec_runner)
      expect(result).to match(/#{targets[0]}/)
      expect(result).to match(/#{targets[1]}/)
    end
    it "jasmineのライブラリーが存在しない場合はSpecRunner生成先にコピーする" do
      expect(Dir.exists?(lib_dir)).to be_false
      spec_runner.generate_spec_runner_html(targets)
      expect(Dir.exists?(lib_dir)).to be_true
      expect(File.exists?("#{lib_dir}/jasmine-#{config[:jasmine_version]}/jasmine.js")).to be_true
      expect(File.exists?("#{lib_dir}/jasmine-#{config[:jasmine_version]}/jasmine-html.js")).to be_true
      result = File.read(dest_spec_runner)
      expect(result).to match(/jasmine-#{config[:jasmine_version]}\/jasmine.js/)
      expect(result).to match(/jasmine-#{config[:jasmine_version]}\/jasmine-html.js/)
    end
    it "jasmineのCSSが存在しない場合はSpecRunner生成先にコピーする" do
      expect(Dir.exists?(lib_dir)).to be_false
      spec_runner.generate_spec_runner_html(targets)
      expect(Dir.exists?(lib_dir)).to be_true
      expect(File.exists?("#{lib_dir}/jasmine-#{config[:jasmine_version]}/jasmine.css")).to be_true
      result = File.read(dest_spec_runner)
      expect(result).to match(/jasmine-#{config[:jasmine_version]}\/jasmine.css/)
    end
  end
end
