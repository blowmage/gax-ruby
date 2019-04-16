# Copyright 2019, Google Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#     * Neither the name of Google Inc. nor the names of its
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

require "google/gax/api_call/options"
require "google/gax/errors"

module Google
  module Gax
    class ApiCall
      attr_reader :stub_method

      ##
      # Creates an API object for making a single RPC call.
      #
      # In typical usage, `stub_method` will be a proc used to make an RPC request. This will mostly likely be a bound
      # method from a request Stub used to make an RPC call.
      #
      # The result is created by applying a series of function decorators defined in this module to `stub_method`.
      #
      # The result is another proc which has the same signature as the original.
      #
      # @param stub_method [Proc] Used to make a bare rpc call.
      #
      def initialize stub_method
        @stub_method = stub_method
      end

      ##
      # Invoke the API call.
      #
      # @param request [Object] The request object.
      # @param options [Hash, ApiCall::Options] The call options. This object should only be used once.
      #
      # @return [Object, Thread] The response object. When `on_stream` is set a thread running the callback for each
      #   streamed response is returned.
      #
      def call request, options: nil, on_response: nil, on_operation: nil, on_stream: nil
        # Converts hash and nil to an options object
        options = ApiCall::Options.new options.to_h if options.respond_to? :to_h
        block = compose_stream_proc on_stream: on_stream, on_response: on_response
        deadline = calculate_deadline options

        begin
          operation = stub_method.call request, deadline: deadline, metadata: options.metadata, return_op: true, &block

          if on_stream
            Thread.new { operation.execute }
          else
            response = operation.execute
            response = on_response.call response if on_response
            on_operation.call response, operation if on_operation
            response
          end
        rescue StandardError => error
          error = Google::Gax::GaxError.wrap error

          if check_retry? deadline
            retry if options.retry_policy.call error
          end

          raise error
        end
      end

      private

      def compose_stream_proc on_stream: nil, on_response: nil
        return unless on_stream
        return on_stream unless on_response

        proc { |response| on_stream.call on_response.call response }
      end

      def calculate_deadline options
        Time.now + options.timeout
      end

      def check_retry? deadline
        deadline > Time.now
      end
    end
  end
end
