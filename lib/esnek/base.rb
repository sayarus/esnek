require 'rest_client'
require 'json'
require 'ostruct'

class Esnek
  attr_accessor :chain, :url_root
  def initialize(url_root)
    @url_root = url_root
    @chain = []
  end

  def method_missing(method_sym, *args, &block)
    if [:get, :put, :post, :delete].include?(method_sym)
      url = @url_root.gsub(/\/$/,'') + '/' + @chain.map{|e| e[:method]}.join('/')
      params = @chain.inject({}){|s,e| s.merge!(e[:arg][:params] || {}) if e[:arg].is_a?(Hash)}
      @chain = []
      OpenStruct.new JSON.parse RestClient.send(method_sym, url, {:params => params})
    else      
      @chain << {:method => method_sym, :arg => args[0] || {} }
      self
    end
  end
    
  def respond_to?(method_sym)
    if [:get, :put, :post, :delete].include?(method_sym)
      true
    else
      super
    end
  end
    
end