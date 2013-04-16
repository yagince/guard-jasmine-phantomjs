# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'
require 'phantomjs'

describe Jasmine::SpecRunner do
  let(:config){
    {
      src_dir: 'spec/data/src',
      spec_dir: 'spec/data/spec',
      jasmine_version: '1.3.1',
      phantomjs: :native,
      reporter: :html
    }
  }
  let(:spec_runner){ Jasmine::SpecRunner.new(config) }
  let(:targets) { ['spec/data/src/a.ts', 'spec/data/src/b/b.ts'] }
  let(:dest_spec_runner) { "#{config[:spec_dir]}/SpecRunner.html" }
  let(:lib_dir) { "#{config.spec_dir}/lib" }

  describe "#generate_spec_runner_html" do
    let(:not_exist_js){ 'spec/data/src/notExist.js'}
    def to_spec(path)
      path.end_with?("Spec.js") ? path : path.sub(path.match(/.+(\..+$)/){|m| m[1]}, "Spec.js")
    end
    after do
      delete_by_pattern(dest_spec_runner)
      FileUtils.remove_dir(lib_dir, true) if Dir.exist?(lib_dir)
    end
    context "reporterがHTMLの場合" do 
      it "指定したファイルのspecを実行し、HTML形式の結果を出力するSpecRunner.htmlを生成する" do
        expect(spec_runner.generate_spec_runner_html(targets)).to be_true

        expect(File.exist?(dest_spec_runner)).to be_true
        result = File.read(dest_spec_runner)
        expect(result).to match(/#{to_spec(targets[0]).sub(config[:src_dir], ".")}/)
        expect(result).to match(/#{to_spec(targets[1]).sub(config[:src_dir], ".")}/)
        expect(result).to match(/new jasmine\.HtmlReporter\(\)/)
      end
    end
    context "reporterがPhantomJsの場合" do
      before do
        config.merge!({reporter: :phantomjs})
      end
      it "指定したファイルのspecを実行し、JUnit形式のXMLを出力するSpecRunner.htmlを生成する" do
        expect(spec_runner.generate_spec_runner_html(targets)).to be_true

        expect(File.exist?(dest_spec_runner)).to be_true
        result = File.read(dest_spec_runner)
        expect(result).to match(/#{to_spec(targets[0]).sub(config[:src_dir], ".")}/)
        expect(result).to match(/#{to_spec(targets[1]).sub(config[:src_dir], ".")}/)
        expect(result).to match(/new jasmine\.TrivialReporter\(\)/)
        expect(result).to match(/new jasmine\.PhantomJSReporter\(\)/)
        expect(result).to match(/lib\/jasmine-#{config[:jasmine_version]}\/jasmine\.phantomjs-reporter\.js/)
      end
    end
    context "reporterがHTMLでもPhantomJsでもない場合" do
      before do
        config.merge!({reporter: :hoge})
      end
      it "repoterがHTMLの場合と同じ結果を出力する" do
        expect(spec_runner.generate_spec_runner_html(targets)).to be_true

        expect(File.exist?(dest_spec_runner)).to be_true
        result = File.read(dest_spec_runner)
        expect(result).to match(/#{to_spec(targets[0]).sub(config[:src_dir], ".")}/)
        expect(result).to match(/#{to_spec(targets[1]).sub(config[:src_dir], ".")}/)
        expect(result).to match(/new jasmine\.HtmlReporter\(\)/)
      end
    end

    context "指定したファイルのspecが存在しない場合" do
      before do
        targets << not_exist_js
      end
      it "存在するspecのみを実行するSpecRunner.htmlを生成する" do
        expect(spec_runner.generate_spec_runner_html(targets)).to be_true

        expect(File.exist?(dest_spec_runner)).to be_true
        result = File.read(dest_spec_runner)
        expect(result).to match(/#{to_spec(targets[0]).sub(config[:src_dir], ".")}/)
        expect(result).to match(/#{to_spec(targets[1]).sub(config[:src_dir], ".")}/)
        expect(result).not_to match(/#{to_spec(targets[2]).sub(config[:src_dir], ".")}/)
      end
    end
    context "指定したファイルのspecが全て存在しない場合" do
      it "SpecRunner.htmlを生成しない" do
        expect(spec_runner.generate_spec_runner_html([not_exist_js])).to be_false

        expect(File.exist?(dest_spec_runner)).to be_false
      end
    end
    context "jasmineのライブラリーが存在しない場合" do 
      it "SpecRunner生成先にライブラリーをコピーする" do
        expect(Dir.exists?(lib_dir)).to be_false
        spec_runner.generate_spec_runner_html(targets)

        expect(Dir.exists?(lib_dir)).to be_true
        expect(File.exists?("#{lib_dir}/jasmine-#{config[:jasmine_version]}/jasmine.js")).to be_true
        expect(File.exists?("#{lib_dir}/jasmine-#{config[:jasmine_version]}/jasmine-html.js")).to be_true
        expect(File.exists?("#{lib_dir}/jasmine-#{config[:jasmine_version]}/jasmine.phantomjs-reporter.js")).to be_true

        result = File.read(dest_spec_runner)
        expect(result).to match(/jasmine-#{config[:jasmine_version]}\/jasmine.js/)
        expect(result).to match(/jasmine-#{config[:jasmine_version]}\/jasmine-html.js/)
      end
    end
    context "jasmineのCSSが存在しない場合" do 
      it "SpecRunner生成先にコピーする" do
        expect(Dir.exists?(lib_dir)).to be_false
        spec_runner.generate_spec_runner_html(targets)
        expect(Dir.exists?(lib_dir)).to be_true
        expect(File.exists?("#{lib_dir}/jasmine-#{config[:jasmine_version]}/jasmine.css")).to be_true
        result = File.read(dest_spec_runner)
        expect(result).to match(/jasmine-#{config[:jasmine_version]}\/jasmine.css/)
      end
    end
  end

  describe "#run" do
    it "指定したファイルのspecを実行するSpecRunnerを生成する" do
      spec_runner.should_receive(:generate_spec_runner_html){}.with(targets)
      spec_runner.run(targets)
    end
    context "gemでPhantomJsを実行する場合" do
      before do
        config.merge!(phantomjs: :gem)
      end
      it "phantomjsでspecを実行する" do
        spec_runner.stub(:generate_spec_runner_html){true}
        Phantomjs.should_receive(:run).with(anything, "#{config[:spec_dir]}/SpecRunner.html")
        spec_runner.run(targets)
      end
    end
    context "nativeでPhantomJsを実行する場合" do
      before do
        config.merge!(phantomjs: :native )
      end
      it "phantomjsでspecを実行する" do
        spec_runner.stub(:generate_spec_runner_html){true}
        Phantomjs.should_not_receive(:run)
        spec_runner.run(targets)
      end
    end
  end
  describe "#run_all" do
    let(:all_specs) { Dir.glob("#{config[:spec_dir]}/**/*.js") }

    before do
      config.merge!({phantomjs: :gem})
    end

    it "全ファイルのspecを実行するSpecRunnerを生成する" do
      Phantomjs.stub(:run)
      spec_runner.should_receive(:generate_spec_runner_html){true}.with(all_specs)
      spec_runner.run_all
    end

    it "phantomjsでspecを実行する" do
      spec_runner.stub(:generate_spec_runner_html){true}
      Phantomjs.should_receive(:run).with(anything, "#{config[:spec_dir]}/SpecRunner.html")
      spec_runner.run_all
    end
  end
end
