require 'spec_helper'
require 'yahoo_keyphrase_api'

describe 'YahooKeyphraseApi' do

  before do
    tokens = YAML.load_file(File.join(File.dirname(__FILE__),'./application.yml'))["test"]
    YahooKeyphraseApi::Config.app_id = tokens['app_id']
    @ykp = YahooKeyphraseApi::KeyPhrase.new
  end

  it 'should get instance' do
    @ykp.should_not == nil
  end

  it 'should get keyphrases case POST' do
    res =  @ykp.extract('東京ミッドタウンから国立新美術館まで歩いて5分で着きます。のリクエストに対するレスポンスです。')
    res.should_not == nil
  end

  it 'should get keyphrases case GET' do
    res =  @ykp.extract('東京ミッドタウンから国立新美術館まで歩いて5分で着きます。のリクエストに対するレスポンスです。', :GET)
    res.should_not == nil
  end

  # NG case
  it 'appid is nil' do
    YahooKeyphraseApi::Config.app_id = nil
    lambda{
      YahooKeyphraseApi::KeyPhrase.new
    }.should raise_error(YahooKeyphraseApi::YahooKeyPhraseApiError, 'please set app key before use')
  end

  it 'invalid arguments' do
    lambda{
      @ykp.extract('東京ミッドタウンから国立新美術館まで歩いて5分で着きます。のリクエストに対するレスポンスです。', :NG)
    }.should raise_error(YahooKeyphraseApi::YahooKeyPhraseApiError, 'invalid request method')
  end

  it '413 Request Entity Too Large' do
    large_file = File.dirname(__FILE__) + '/LargeData.txt'
    p FileTest.size?(large_file) # its 33KB! why error? :(
    c = File.read(large_file)

    lambda{
      res =  @ykp.extract(c)
    }.should raise_error(YahooKeyphraseApi::YahooKeyPhraseApiError, 'Request Entity Too Large')
  end

end