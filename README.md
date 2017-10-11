# gruf-circuit-breaker - Circuit Breaker for gruf

[![Build Status](https://travis-ci.org/bigcommerce/gruf-circuit-breaker.svg?branch=master)](https://travis-ci.org/bigcommerce/gruf-circuit-breaker) [![Gem Version](https://badge.fury.io/rb/gruf-circuit-breaker.svg)](https://badge.fury.io/rb/gruf-circuit-breaker) [![Inline docs](http://inch-ci.org/github/bigcommerce/gruf-circuit-breaker.svg?branch=master)](http://inch-ci.org/github/bigcommerce/gruf-circuit-breaker) 

Adds circuit breaker support for [gruf](https://github.com/bigcommerce/gruf) 2.0.0 or later.

This uses the wonderful [stoplight](https://github.com/orgsync/stoplight) gem for handling
the internals of circuit breaking.

## Installation

```ruby
gem 'gruf-circuit-breaker'
```

Then in an initializer or before use, after loading gruf:

```ruby
require 'gruf/circuit_breaker'
Gruf::Hooks::Registry.add(:circuit_breaker, Gruf::CircuitBreaker::Hook)
```

## Configuration

You can further customize the tracing of gruf services via the configuration:

```ruby
Gruf.configure do |c|
  c.interceptors.use(Gruf::CircuitBreaker::Interceptor, { 
    # set cool-off time in seconds (defaults to 60)
    cool_off_time: 15, 
    # set threshold count to 2
    threshold: 2, 
    # set the gRPC failure statuses that will cause a circuit to trip 
    failure_statuses: [GRPC::Internal, GRPC::Unknown, GRPC::Aborted],
    # use a redis instance for the stoplight data storage
    redis: Redis.new
  })
end
```

## License

Copyright (c) 2017-present, BigCommerce Pty. Ltd. All rights reserved 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the 
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit 
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the 
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
