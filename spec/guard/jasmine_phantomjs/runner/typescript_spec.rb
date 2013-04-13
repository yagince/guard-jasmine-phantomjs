# -*- coding: utf-8 -*-
require 'spec_helper'

describe Guard::JasminePhantomjs::Runner::TypeScript do
  let(:src_dir){ "spec/data/src" }
  let(:config){ {src_dir: src_dir} }
  let(:path){ "hoge/foo/bar" }
  let(:result){ {message: "hoge", status: :success} }

  let(:runner){Guard::JasminePhantomjs::Runner::TypeScript.new(config)}

  after do
    delete_by_pattern("#{src_dir}/**/*.js")
  end

  describe "#run" do
    it "指定したパスのtsファイルをコンパイルする" do
      compiler = double("Compiler::TypeScript")
      Compiler::TypeScript.should_receive(:new).with(config).and_return(compiler)
      compiler.should_receive(:compile).with(path).once.and_return(result)
      expect(runner.run([path])[0]).to eq(result)
    end
  end

  describe "#run_all" do
    it "全てのタイプスクリプトファイルをコンパイルする" do
      expect(Dir.glob("#{src_dir}/**/*.js")).to be_empty
      runner.run_all
      Dir.glob("#{src_dir}/**/*.ts").each{|file| expect(File.exists?(file.sub('.ts','.js'))).to be_true }
    end
  end
end
