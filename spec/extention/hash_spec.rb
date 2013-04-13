# -*- coding: utf-8 -*-
require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

describe Hash do
  subject{ {a:1, "z" => 100} }
  context "指定したキーが存在する場合" do 
    it "プロパティのようにキーを指定できる" do
      expect(subject.a).to eq(1)
      expect(subject.z).to eq(100)
    end
  end
  context "指定したキーが存在しない場合" do
    it "エラーになる" do
      expect{ subject.b }.to raise_error
    end
  end
end
