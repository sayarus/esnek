require 'rest_client'
require 'json'
require 'ostruct'

# _Esnek_ provides a quick Ruby interface for JSON  APIs, such as _ElasticSearch_ (http://www.elasticsearch.org); a scalable, fast, distributed, 
# highly-available, real time search RESTful search engine communicating by JSON over HTTP, based on _Lucene_ (http://lucene.apache.org). 
class Esnek
  attr_accessor :chain, :url_root
  def initialize(url_root,json_api=true)
    @url_root = url_root
    @chain = []
    @json_api = json_api
  end

  def parse_json(resp)
    j = JSON.parse resp
    case
    when j.is_a?(Hash)
      r=OpenStruct.new(j)
      class << r;def table;@table;end;end
      r
    when j.is_a?(Array)
      j.map{|e| r=OpenStruct.new(e);class << r;def table;@table;end;end;r}
    else
      j
    end
  end
  def method_missing(method_sym, *args, &block)
    if [:get, :put, :post, :delete].include?(method_sym)
      @chain << {:method => nil, :arg => (args.empty? ? {} : args[0]) }
      url = @url_root.gsub(/\/$/,'') + '/' + @chain.map{|e| e[:method]}.compact.join('/')
      params = @chain.inject({}){|s,e| s.merge!(e[:arg] || {}) if e[:arg].is_a?(Hash)}
      @chain = []      
      resp = if block_given?
               data = block.call rescue nil
               if @json_api                 
                 RestClient.send(method_sym, url, data.to_json, {:params => params,:content_type => :json, :accept => :json})
               else
                 RestClient.send(method_sym, url, data, {:params => params})
               end
             else
               if @json_api                 
                 RestClient.send(method_sym, url, {:params => params, :content_type => :json, :accept => :json})
               else
                 RestClient.send(method_sym, url, {:params => params})
               end
             end
            
      resp.headers[:content_type].include?('application/json') ? parse_json(resp) : resp
    else      
      @chain << {:method => method_sym.to_s.gsub(/^__/,''), :arg => (args.empty? ? {} : args[0]) }
      self
    end
  rescue
    @chain = []
    raise $!
  end
    
  def respond_to?(method_sym)
    if [:get, :put, :post, :delete].include?(method_sym)
      true
    else
      super
    end
  end
    
end
