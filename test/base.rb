# encoding: utf-8
require 'rubygems'
require './lib/esnek'
require 'minitest/autorun'

describe Esnek do
  before do      
  end

  describe "When I query Facebook graph API to count the # of shares of url" do
    it "should return an object which responds to :shares" do
      fb = Esnek.new('http://graph.facebook.com')
      res = fb.send(:"http://www.wsirussia.ru").get
      assert res.respond_to?(:shares)
    end
  end

end
