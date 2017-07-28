require 'rake'

Gem::Specification.new do |spec|
  spec.name = 'teachable_api'
  spec.version = '0.0.1'
  spec.summary = 'Ruby-based wrapper library for the Teachable Mock API.'
  spec.authors = ['Sinclair Target']
  spec.email = 'sinclairtarget@gmail.com'
  spec.homepage = 'https://github.com/sinclairtarget/teachable_api'
  spec.licenses = ['MIT']

  spec.files = FileList['lib/**/*.rb', 'LICENSE.txt', 'README.md']

  spec.add_runtime_dependency 'faraday', ['~> 0.12']
  spec.add_runtime_dependency 'faraday_middleware', ['~> 0.11']
end
