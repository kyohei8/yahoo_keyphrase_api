require "yahoo_keyphrase_api/version"
require 'multi_json'
require 'hashie'
require 'nokogiri'
require 'httparty'

module YahooKeyphraseApi

  SITE_URL = 'http://jlp.yahooapis.jp/KeyphraseService/V1/extract'

  class YahooKeyPhraseApiError < StandardError;
  end

  module Config

    def self.app_key
      @@app_key
    end

    def self.app_key=(val)
      @@app_key = val
    end

    def self.app_secret
      @@app_secret
    end

    def self.app_secret=(val)
      @@app_secret = val
    end
  end


  #
  # usage:
  #   require "yahoo_keyphrase_api"
  #
  #   YahooKeyphraseApi.new [APIKEY]
  #
  # or
  #   YahooKeyphraseApi::Config.app_key = [APIKEY]
  #   YahooKeyphraseApi.new
  #
  class KeyPhrase


    def initialize(app_key = YahooKeyphraseApi::Config.app_key)
      @app_key = app_key
      raise YahooKeyPhraseApiError.new('please set app key before use') unless @app_key
    end

    #
    # @param sentence max:100KB(=日本語51,200文字)
    # @param method :GET or :POST
    # @return hash
    def extract(sentence='', method=:POST)
      if method == :GET
        response = HTTParty.get("#{SITE_URL}?appid=#{@app_key}&sentence=#{URI.escape(sentence)}&output=json")
        response.body
      elsif method == :POST
        response = HTTParty.post("#{SITE_URL}", {
          body: {
            appid: @app_key,
            sentence: sentence,
            output: 'json'
          }
        })
        raise YahooKeyPhraseApiError.new(response.message) if response.code == 413
        Hashie::Mash.new MultiJson.decode(response.body)
      else
        raise YahooKeyPhraseApiError.new('invalid request method')
      end
    end
  end

end
