# frozen_string_literal: true

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
module Gruf
  module CircuitBreaker
    ##
    # Intercepts gruf requests and adds a circuit breaker implementation
    #
    class Interceptor < Gruf::Interceptors::ServerInterceptor
      DEFAULT_FAILURE_STATUSES = [GRPC::Internal, GRPC::Unknown].freeze

      ##
      # Sets up the stoplight gem
      #
      def initialize(request, error, options = {})
        redis = options.fetch(:redis, nil)
        ::Stoplight::Light.default_data_store = ::Stoplight::DataStore::Redis.new(redis) if defined?(::Redis) && redis.is_a?(::Redis)
        super(request, error, options)
      end

      ##
      # Handle the gruf around hook
      #
      def call
        light = Stoplight(request.method_key) do
          yield
        end
        light.with_cool_off_time(options.fetch(:cool_off_time, 60))
        light.with_error_handler do |error, handle|
          # if it's not a gRPC::BadStatus, pass it through
          raise error unless error.is_a?(GRPC::BadStatus)

          # only special handling for GRPC error statuses. We want to pass-through any normal exceptions
          raise error unless failure_statuses.include?(error.class)

          handle.call(error)
        end
        light.with_threshold(threshold) if threshold.to_i.positive?
        light.run
      end

      private

      ##
      # @return [Integer]
      #
      def threshold
        options.fetch(:threshold, 0).to_i
      end

      ##
      # @return [Array<Class>]
      #
      def failure_statuses
        options.fetch(:failure_statuses, DEFAULT_FAILURE_STATUSES)
      end
    end
  end
end
