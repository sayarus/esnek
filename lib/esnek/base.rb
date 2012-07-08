require 'rest_client'
require 'json'
require 'ostruct'

# _Esnek_ provides a quick Ruby interface for JSON  APIs, such as _ElasticSearch_ (http://www.elasticsearch.org); a scalable, fast, distributed, 
# highly-available, real time search RESTful search engine communicating by JSON over HTTP, based on _Lucene_ (http://lucene.apache.org). 
class Esnek
  attr_accessor :chain, :url_root
  def initialize(url_root,options={:json_api=>true,:headers=>{}})
    @url_root = url_root
    @chain = []
    @json_api = options[:json_api]
    @headers= options[:headers]
    if options[:oauth] # Esnek assumes that oauth ruby gem is installed
      options[:oauth][:scheme] ||= :header
      consumer = OAuth::Consumer.new(options[:oauth][:consumer_key],options[:oauth][:consumer_secret], {:site => options[:oauth][:site], :scheme => options[:oauth][:scheme]})
      @access_token = OAuth::AccessToken.from_hash(consumer, {:oauth_token => options[:oauth][:oauth_token], :oauth_token_secret => options[:oauth][:oauth_token_secret]} )
    end
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
    if [:get, :put, :post, :delete, :patch, :head].include?(method_sym)
      @chain << {:method => nil, :arg => (args.empty? ? {} : args[0]) }
      url = @url_root.gsub(/\/$/,'') + '/' + @chain.map{|e| e[:method]}.compact.join('/')
      params = @chain.inject({}){|s,e| s.merge!(e[:arg] || {}) if e[:arg].is_a?(Hash)}
      @chain = []
      headers = {:params => params}.merge!(@headers)
      data = block_given? ? block.call : nil rescue nil

      # if a JSON api is set in initializer both the payload data and the result will be un/jsonized
      if @json_api
        headers.merge!({:content_type => :json, :accept => :json})
        data = data.to_json if data rescue nil
      end
      # if a oauth token exist, use it; unfortunately restclient does not allow a proper
      if @access_token
        access_token=@access_token
        RestClient.reset_before_execution_procs
        RestClient.add_before_execution_proc do |req, params|
          access_token.sign! req
        end
      end
      resp =  if [:put, :post,:patch].include?(method_sym)
                RestClient.send(method_sym, url, data, headers)
              else
                RestClient.send(method_sym, url, headers)
              end
      
      if resp.headers[:content_type] && resp.headers[:content_type].include?('application/json')
        parse_json(resp)
      else
        resp
      end
    else      
      @chain << {:method => method_sym.to_s.gsub(/^__/,''), :arg => (args.empty? ? {} : args[0]) }
      self
    end
  rescue
    @chain = []
    raise $!
  end
  
  def respond_to?(method_sym)
    if [:head,:get, :put, :post,:patch, :delete].include?(method_sym)
      true
    else
      super
    end
  end
  
end
