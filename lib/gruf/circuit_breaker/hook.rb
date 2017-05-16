# Copyright 2017, Bigcommerce Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
# 3. Neither the name of BigCommerce Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
        light = Stoplight(method_key(call_signature)) {
          block.call(call_signature, request, active_call)
        }.with_cool_off_time(options.fetch(:cool_off_time, 60))
         .with_error_handler do |error, handle|
          if error.is_a?(GRPC::BadStatus)
            # only special handling for GRPC error statuses. We want to pass-through any normal exceptions
            raise error unless failure_statuses.include?(error.class)
            handle.call(error)
          else
            raise error
          end
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
        service.class.name.underscore.gsub('/','.')
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

