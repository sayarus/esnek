# encoding: utf-8
require 'rubygems'
require './lib/esnek'
require 'minitest/autorun'

describe Esnek do
  before do
  end

  describe "When I query json placeholder API" do
    it "should return an object" do
      esnek = Esnek.new('https://jsonplaceholder.typicode.com/')
      res = esnek.todos.__1.get
      assert_equal 1, res.id
    end

    it "should put" do
      esnek = Esnek.new('https://jsonplaceholder.typicode.com/')
      res = esnek.todos.__1.put { { title: 'A' }} 
      assert_equal 1, res.id
    end

    it "should post" do
      esnek = Esnek.new('https://jsonplaceholder.typicode.com/')
      res = esnek.todos.post { { title: 'A' }} 
      assert res.id > 0
    end

    it "should delete" do
      esnek = Esnek.new('https://jsonplaceholder.typicode.com/')
      res = esnek.todos.__1.delete
      assert res.id.nil?
    end
  end
end
