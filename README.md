# Yahoo Keyphrase Api Client

This is Yahoo Keyphrase Api Client for ruby.

### API documentation
[Yahoo Keyphrase API documentation](http://developer.yahoo.co.jp/webapi/jlp/keyphrase/v1/extract.html)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yahoo_keyphrase_api'
```
and `bundle install`

or

```sh
$ gem install yahoo_keyphrase_api
```

## Configuration

```ruby
require 'yahoo_keyphrase_api'

# and setup
YahooKeyphraseApi::Config.app_id = [application_ID]
```

## Usage

```ruby
ykp = YahooKeyphraseApi::KeyPhrase.new

# extract key phrase
ykp.extract '東京ミッドタウンから国立新美術館まで歩いて5分で着きます。のリクエストに対するレスポンスです。'
 #=> <Hashie::Mash 5分=10 リクエスト=55 国立新美術館=100 東京ミッドタウン=69>
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
