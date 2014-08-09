# encoding: utf-8
require 'rubygems'
require './lib/esnek'
require 'minitest/autorun'

describe Esnek do
  before do      
  end

  describe "When I query Google URL Shortener API" do
   it "should return a shortened URL" do
     gapi = Esnek.new('https://www.googleapis.com')
     res = gapi.urlshortener.v1.url.post {{:longUrl => "http://www.resimit.com/"}}
     puts res.inspect
   end
  end 

  describe "When I query Facebook graph API to count the # of shares of url" do
    it "should return an object which responds to :shares" do
      fb = Esnek.new('http://graph.facebook.com')
      res = fb.send(:"http://www.resimit.com").get
      assert res.respond_to?(:shares)
      puts res.inspect
    end
  end

end
