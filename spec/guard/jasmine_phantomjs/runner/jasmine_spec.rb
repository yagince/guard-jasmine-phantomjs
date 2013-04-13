# -*- coding: utf-8 -*-
require 'spec_helper'

describe Guard::JasminePhantomjs::Runner::Jasmine do
  let(:config){ {} }
  let(:runner){ Guard::JasminePhantomjs::Runner::Jasmine.new(config) }
  let(:targets){ ["spec/data/src/sample.js"] }
  describe "#run" do
    it "指定したファイルのspecを実行して結果を返す" do
      spec_runner = double('spec_runner')
      Jasmine::SpecRunner.stub(:new){spec_runner}
      spec_runner.should_receive(:run).with(targets)
      runner.run(targets)
    end
  end
  describe "#run_all" do
    it "全ファイルファイルのspecを実行して結果を返す" do
      spec_runner = double('spec_runner')
      Jasmine::SpecRunner.stub(:new){spec_runner}
      spec_runner.should_receive(:run_all)
      runner.run_all
    end
  end
end
