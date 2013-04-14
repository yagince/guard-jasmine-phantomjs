# -*- coding: utf-8 -*-
require 'spec_helper'

describe Compiler::TypeScript do
  let(:ts_file) { "./spec/data/sample.ts" }
  let(:invalid_ts_file) { "./spec/data/invalid-sample.ts" }
  let(:js_file) { "./spec/data/sample.js" }
  let(:compiler) { Compiler::TypeScript.new(ts_file) }

  describe "#compile" do
    context "コンパイルが成功する場合" do 
      after do
        delete_by_pattern(js_file)
      end
      it "should be compile ts -> js" do
        compiler.compile(ts_file)
        expect(File.exist?(js_file)).to be_true
      end
      it "should be return result" do
        result = compiler.compile(ts_file)
        expect(result.message).to eq("")
        expect(result.status).to eq(:success)
      end
    end
  end

  context "コンパイルエラーになる場合" do
    it "should be return error-result" do
      result = compiler.compile(invalid_ts_file)
      expect(result.message).to match(/.+: Function declared a non-void return type, but has no return expression/)
      expect(result.status).to eq(:error)
    end
  end
end
