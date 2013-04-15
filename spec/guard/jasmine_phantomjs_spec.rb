# -*- coding: utf-8 -*-
require 'yaml'
require 'spec_helper'

describe Guard::JasminePhantomjs do
  let(:config){
    {
      'src_dir' => 'spec/data/src',
      'spec_dir' => 'spec/data/spec',
      jasmine_version: '1.3.1',
      phantomjs: :gem
    }
  }
  let(:default_guard) { Guard::JasminePhantomjs.new([], config) }
  let(:guard) { Guard::JasminePhantomjs.new([], config.merge({ compile: :coffee })) }
  let(:invalid_option_guard) { Guard::JasminePhantomjs.new([], config.merge({compile: :hoge})) }
  
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
      let(:success){{message: "", status: 0}}
      let(:path1){"hoge"}
      let(:path2){"foo"}
      let(:paths){[path1, path2]}
      let(:compile_runner){ double("compile_runner") }
      let(:jasmine_runner){ double("jasmine_runner") }

      before do
        Guard::JasminePhantomjs::Runner::TypeScript.stub(:new){ compile_runner }
        Guard::JasminePhantomjs::Runner::Jasmine.stub(:new){ jasmine_runner }
      end

      it "変更対象のファイルがコンパイルされる" do
        jasmine_runner.stub(:run){}
        compile_runner.should_receive(:run){[success]}.with(paths)
        default_guard.run_on_changes(paths)
      end
      context "コンパイル成功の場合" do 
        it "変更対象のファイルのspecを実行する" do
          compile_runner.stub(:run){[success]}
          jasmine_runner.should_receive(:run).with(paths)
          default_guard.run_on_changes(paths)
        end
      end
      context "コンパイルエラーの場合" do 
        it "変更対象のファイルのspecは実行されない" do
          compile_runner.should_receive(:run){[{status: :error}]}.at_least(:once)
          jasmine_runner.should_not_receive(:run)
          default_guard.run_on_changes(paths)
        end
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
