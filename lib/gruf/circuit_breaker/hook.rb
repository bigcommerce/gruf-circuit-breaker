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
module Gruf
  module CircuitBreaker
    class Hook < Gruf::Hooks::Base

      ##
      # Sets up the stoplight gem
      #
      def setup
        redis = options.fetch(:redis, nil)
        Stoplight::Light.default_data_store = Stoplight::DataStore::Redis.new(redis) if redis && redis.is_a?(Redis)
      end

      ##
      # Handle the gruf around hook
      #
      # @param [Symbol] call_signature
      # @param [Object] request
      # @param [GRPC::ActiveCall] active_call
      #
      def around(call_signature, request, active_call, &block)
        light = Stoplight(method_key(call_signature)) do
          block.call(call_signature, request, active_call)
        end
        light.with_cool_off_time(options.fetch(:cool_off_time, 60))
        light.with_error_handler do |error, handle|
          # if it's not a gRPC::BadStatus, pass it through
          raise error unless error.is_a?(GRPC::BadStatus)
          # only special handling for GRPC error statuses. We want to pass-through any normal exceptions
          raise error unless failure_statuses.include?(error.class)
          handle.call(error)
        end
        light.with_threshold(options.fetch(:threshold, 1)) if options.fetch(:threshold, false)
        light.run
      end

      private

      ##
      # @return [String]
      #
      def method_key(call_signature)
        "#{service_key}.#{call_signature.to_s.gsub('_without_intercept', '')}"
      end

      ##
      # @return [String]
      #
      def service_key
        service.class.name.underscore.tr('/', '.')
      end

      ##
      # @return [Array<Class>]
      #
      def failure_statuses
        options.fetch(:failure_statuses, [GRPC::Internal, GRPC::Unknown])
      end

      ##
      # @return [Hash]
      #
      def options
        @options.fetch(:circuit_breaker, {})
      end
    end
  end
end
