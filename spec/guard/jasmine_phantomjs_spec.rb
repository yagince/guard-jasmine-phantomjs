# -*- coding: utf-8 -*-
require 'yaml'
require 'spec_helper'

describe Guard::JasminePhantomjs do
  let(:config) { YAML.load_file('config/jasmine.yml') }
  let(:default_guard) { Guard::JasminePhantomjs.new }
  let(:guard) { Guard::JasminePhantomjs.new([], { compile: :coffee }) }
  let(:invalid_option_guard) { Guard::JasminePhantomjs.new([], { compile: :hoge }) }
  
  context "デフォルト設定時" do
    describe ":compile option" do
      subject{ default_guard.options[:compile] }
      it { should == :typescript }
    end
    describe "#start" do
      
      after {
        Dir.glob("#{config.src_dir}/**/*.js").each {|file| File.delete(file) }
      }
      it "should be compile all sources" do
        default_guard.start
        Dir.glob("#{config.src_dir}/**/*.ts").each {|file| expect(File.exist?(file.sub('.ts','.js'))).to be_true }
      end
    end
  end

  context "オプション指定時" do
    describe ":compile option" do
      subject{ guard.options[:compile] }
      it { should == :coffee }
      context "typescript と coffee以外の場合" do
        subject{ invalid_option_guard.options[:compile] }
        it { should == :typescript }
      end
    end
  end
end
