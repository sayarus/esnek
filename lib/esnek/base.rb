require 'rest_client'
require 'json'

# _Esnek_ provides a quick Ruby interface for JSON  APIs, such as _ElasticSearch_ (http://www.elasticsearch.org); a scalable, fast, distributed,
# highly-available, real time search RESTful search engine communicating by JSON over HTTP, based on _Lucene_ (http://lucene.apache.org).
class Esnek
  #attr_accessor :esnek_chain, :esnek_url_root, :esnek_params, :esnek_url
  def initialize(esnek_url_root, options={:verify_ssl=>true, :json_api=>true,:json_return=>true, :header=>{}})
    @esnek_url_root = esnek_url_root
    @esnek_chain = []
    @json_api = options[:json_api].nil? ? true : options[:json_api]
    @json_return = options[:json_return].nil? ? @json_api : options[:json_return]
    @verify_ssl = options[:verify_ssl]
    @header= options[:header] || {}
    if options[:oauth] # Esnek assumes that oauth ruby gem is installed
      options[:oauth][:scheme] ||= :header
      consumer = OAuth::Consumer.new(options[:oauth][:consumer_key],options[:oauth][:consumer_secret], {:site => options[:oauth][:site], :scheme => options[:oauth][:scheme]})
      @access_token = OAuth::AccessToken.from_hash(consumer, {:oauth_token => options[:oauth][:oauth_token], :oauth_token_secret => options[:oauth][:oauth_token_secret]} )
    else
      @access_token = nil
    end
  end

  def parse_json(resp)
    j = JSON.parse resp
    case
    when j.is_a?(Hash)
      r = OpenStruct.new(j)
      class<<r;def table;@table;end;end;
      r
    when j.is_a?(Array)
      j.map do |e|
        r= if e.is_a?(Hash)
             r = OpenStruct.new(e)
             class<<r;def table;@table;end;end;
           else
             e
           end
        r
      end
    else
      j
    end
  end
  def method_missing(method_sym, *args, &block)
    if [:get, :put, :post, :delete, :patch, :head].include?(method_sym)
      @esnek_chain << {:method => nil, :arg => (args.empty? ? {} : args[0]) }
      @esnek_url = @esnek_url_root.gsub(/\/$/,'') + '/' + @esnek_chain.map{|e| e[:method]}.compact.join('/')
      @esnek_params = @esnek_chain.inject({}){|s,e| s.merge!(e[:arg] || {}) if e[:arg].is_a?(Hash)}
      @esnek_chain = []
      heades = {:params => @esnek_params}.merge(@header)
      data = block_given? ? block.call : nil #rescue nil

      # if a JSON api is set in initializer both the payload data and the result will be un/jsonized
      if @json_api
        heades.merge!({:content_type => :json, :accept => :json})
        data = data.to_json if data #rescue nil
      elsif data.is_a? Hash
        data = data.map{|k,v| "#{CGI::escape(k)}=#{CGI::escape(v)}"}.join('&')
      end
      # if a oauth token exist, use it; unfortunately restclient does not allow a proper
      RestClient.reset_before_execution_procs
      RestClient.add_before_execution_proc do |req, par|
        @access_token.sign! req
      end if @access_token
      resp =  if [:put, :post,:patch].include?(method_sym)
                RestClient::Request.execute(:method=>method_sym, :url=>@esnek_url, :payload=>data, :headers=>heades, :verify_ssl=>@verify_ssl)
              else
                RestClient::Request.execute(:method=>method_sym, :url=>@esnek_url, :headers=>heades, :verify_ssl=>@verify_ssl)
              end

      if @json_return
        parse_json(resp)
      else
        resp
      end
    else
      @esnek_chain << {:method => method_sym.to_s.gsub(/^__/,''), :arg => (args.empty? ? {} : args[0]) }
      self
    end
  rescue
    @esnek_chain = []
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
