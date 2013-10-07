# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yahoo_keyphrase_api/version'

Gem::Specification.new do |spec|
  spec.name          = "yahoo_keyphrase_api"
  spec.version       = YahooKeyphraseApi::VERSION
  spec.authors       = ["kyohei8"]
  spec.email         = ["tsukuda.kyouhei@gmail.com"]
  spec.description   = %q{yahoo keyphrase api client}
  spec.summary       = %q{yahoo keyphrase api client}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency 'multi_json'
  spec.add_runtime_dependency 'httparty'
  spec.add_runtime_dependency 'hashie'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
end
