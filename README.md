# gruf-circuit-breaker - Circuit Breaker for gruf

[![Build Status](https://travis-ci.com/bigcommerce/gruf-circuit-breaker.svg?token=D3Cc4LCF9BgpUx4dpPpv&branch=master)](https://travis-ci.com/bigcommerce/gruf-circuit-breaker)

Adds circuit breaker support for [gruf](https://github.com/bigcommerce/gruf) 0.12.0 or later.

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
  c.hook_options = {
    circuit_breaker: {
      # set cool-off time in seconds (defaults to 60)
      cool_off_time: 15, 
      # set threshold count to 2
      threshold: 2, 
      # set the gRPC failure statuses that will cause a circuit to trip 
      failure_statuses: [GRPC::Internal, GRPC::Unknown, GRPC::Aborted],
      # use a redis instance for the stoplight data storage
      redis: Redis.new
    }
  }
end
```

## License

Copyright 2017, Bigcommerce Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above
copyright notice, this list of conditions and the following disclaimer
in the documentation and/or other materials provided with the
distribution.
* Neither the name of BigCommerce Inc. nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
