# -*- coding: utf-8 -*-
require 'spec_helper'

describe Compiler::TypeScript do
  let(:ts_file) { "spec/data/sample.ts" }
  let(:invalid_ts_file) { "spec/data/invalid-sample.ts" }
  let(:js_file) { "spec/data/sample.js" }
  let(:compiler) { Compiler::TypeScript.new(ts_file) }
  let(:compiler_invalid) { Compiler::TypeScript.new(invalid_ts_file) }
  describe "#compile" do
    context "コンパイルが成功する場合" do 
      after do
        File.delete(js_file) if File.exist?(js_file)
      end
      it "should be compile ts -> js" do
        compiler.compile
        expect(File.exist?(js_file)).to be_true
      end
      it "should be return result" do
        result = compiler.compile
        expect(result.message).to eq("")
        expect(result.status).to eq(:success)
      end
    end
  end
  context "コンパイルエラーになる場合" do
    it "should be return error-result" do
      result = compiler_invalid.compile
      # TODO: メッセージを受け取れるようにする
      expect(result.message).to match(/.+: Function declared a non-void return type, but has no return expression/)
      expect(result.status).to eq(:error)
    end
  end
end
