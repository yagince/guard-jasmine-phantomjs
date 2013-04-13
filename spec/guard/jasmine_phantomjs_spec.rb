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
      after do
        Dir.glob("#{config.src_dir}/**/*.js").each {|file| File.delete(file) }
      end

      it "should be compile all sources" do
        default_guard.start
        Dir.glob("#{config.src_dir}/**/*.ts").each {|file| expect(File.exist?(file.sub('.ts','.js'))).to be_true }
      end
    end

    describe "#run_on_changes" do
      let(:path1){"hoge"}
      let(:path2){"foo"}
      let(:paths){[path1, path2]}

      it "変更対象のファイルがコンパイルされる" do
        runner = double("compile_runner")
        Guard::JasminePhantomjs::Runner::TypeScript.stub(:new){ runner }
        runner.should_receive(:run).with(path1)
        runner.should_receive(:run).with(path2)
        default_guard.run_on_changes(paths)
      end
    end
  end

  context "オプション指定時" do
    describe ":compile option" do
      context "指定可能なコンパイラの場合" do 
        subject{ guard.options[:compile] }
        it { should == :coffee }
      end
      context "指定可能なコンパイラ以外の場合" do
        subject{ invalid_option_guard.options[:compile] }
        it { should == :typescript }
      end
    end
  end
end
