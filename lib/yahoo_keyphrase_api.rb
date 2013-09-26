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
        #puts response.body, response.code, response.message, response.headers.inspect
        raise YahooKeyPhraseApiError.new(response.message) if response.code == 413
        Hashie::Mash.new MultiJson.decode(response.body)
      else
        raise YahooKeyPhraseApiError.new('invalid request method')
      end
    end
  end

=begin
  class Hash
    class << self
      def from_libxml(xml)
        begin
          result = Nokogiri::XML(xml)
          return {result.root.name.to_s.to_sym => xml_node_to_hash(result.root)}
        rescue Exception => e
          # raise your custom exception here
        end
      end

      def xml_node_to_hash(node)
        # If we are at the root of the document, start the hash
        if node.element?
          if node.children.present?
            result_hash = {}

            node.children.each do |child|
              result = xml_node_to_hash(child)

              if child.name == "text"
                if !child.next_element.present? and !child.previous_element.present?
                  return result
                end
              elsif result_hash[child.name.to_sym]
                if result_hash[child.name.to_sym].is_a?(Object::Array)
                  result_hash[child.name.to_sym] << result
                else
                  result_hash[child.name.to_sym] = [result_hash[child.name.to_sym]] << result
                end
              else
                result_hash[child.name.to_sym] = result
              end
            end
            return result_hash
          elsif node.attributes.present?
            # TODO
          else
            return nil
        else
          return node.content.to_s
          end
        end
      end
    end
  end
=end

end
