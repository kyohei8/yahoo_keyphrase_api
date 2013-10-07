require "yahoo_keyphrase_api/version"
require 'multi_json'
require 'hashie'
require 'httparty'

module YahooKeyphraseApi

  SITE_URL = 'http://jlp.yahooapis.jp/KeyphraseService/V1/extract'

  class YahooKeyPhraseApiError < StandardError
  end

  module Config

    def self.app_id
      @@app_id
    end

    def self.app_id=(val)
      @@app_id = val
    end
  end

  #
  class KeyPhrase
    # initializer if creating a new Yahoo Keyphrase API client
    # @param appid Yahoo APP id
    def initialize(appid = YahooKeyphraseApi::Config.app_id)
      @app_key = appid
      raise YahooKeyPhraseApiError.new('please set app key before use') unless @app_key
    end

    # Retrieve a keyphrase
    # @param sentence
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
        # 413 Request Entity Too Large
        raise YahooKeyPhraseApiError.new(response.message) if response.code == 413
        Hashie::Mash.new MultiJson.decode(response.body)
      else
        # invalid arguments
        raise YahooKeyPhraseApiError.new('invalid request method')
      end
    end
  end

end
