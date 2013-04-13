# -*- coding: utf-8 -*-
require 'spec_helper'

describe Compiler::Compiler do

  let(:compiler) { Compiler::Compiler.new }

  describe "#compile" do
    it "raise error" do
      expect{ compiler.compile("") }.to raise_error(NotImplementedError)
    end
  end
end
