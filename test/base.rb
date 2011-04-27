# encoding: utf-8
require 'rubygems'
require './lib/esnek'
require 'minitest/autorun'

describe Esnek do
  before do
    @esnek=Esnek.new
  end

  describe "When an esnek against public APIs is given" do
    it "should return call a .." do
      @esnek.get
    end
  end
  
end
