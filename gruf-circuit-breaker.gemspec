# coding: utf-8
# Copyright (c) 2017-present, BigCommerce Pty. Ltd. All rights reserved
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
$:.push File.expand_path("../lib", __FILE__)
require 'gruf/circuit_breaker/version'

Gem::Specification.new do |spec|
  spec.name          = 'gruf-circuit-breaker'
  spec.version       = Gruf::CircuitBreaker::VERSION
  spec.authors       = ['Shaun McCormick']
  spec.email         = ['shaun.mccormick@bigcommerce.com']

  spec.summary       = %q{Plugin for implementing the circuit breaker pattern for gruf gRPC requests}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/bigcommerce/gruf-circuit-breaker'
  spec.license       = 'MIT'

  spec.files         = Dir['README.md', 'CHANGELOG.md', 'CODE_OF_CONDUCT.md', 'lib/**/*', 'gruf-circuit-breaker.gemspec']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'pry', '~> 0'

  spec.add_runtime_dependency 'stoplight', '~> 2.1'
end
