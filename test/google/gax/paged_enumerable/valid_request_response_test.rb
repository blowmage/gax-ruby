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
# 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'test_helper'

class PagedEnumerableValidRequestResponseTest < Minitest::Test
  def test_GoodPagedRequest_GoodPagedResponse
    api_responses = [
      Google::Gax::GoodPagedResponse.new(
        users: [
          Google::Gax::User.new(name: 'baz'),
          Google::Gax::User.new(name: 'bif')
        ]
      )
    ]
    api_call = ->(_req, _opt) { api_responses.shift }
    request = Google::Gax::GoodPagedRequest.new
    response = Google::Gax::GoodPagedResponse.new(
      users: [
        Google::Gax::User.new(name: 'foo'),
        Google::Gax::User.new(name: 'bar')
      ],
      next_page_token: 'next'
    )
    options = Google::Gax::CallOptions.new
    paged_enum = Google::Gax::PagedEnumerable.new(
      api_call, request, response, options
    )

    assert_equal %w[foo bar baz bif], paged_enum.map(&:name)
  end

  def test_Int64PagedRequest
    api_responses = [
      Google::Gax::GoodPagedResponse.new(
        users: [
          Google::Gax::User.new(name: 'baz'),
          Google::Gax::User.new(name: 'bif')
        ]
      )
    ]
    api_call = ->(_req, _opt) { api_responses.shift }
    request = Google::Gax::Int64PagedRequest.new
    response = Google::Gax::GoodPagedResponse.new(
      users: [
        Google::Gax::User.new(name: 'foo'),
        Google::Gax::User.new(name: 'bar')
      ],
      next_page_token: 'next'
    )
    options = Google::Gax::CallOptions.new
    paged_enum = Google::Gax::PagedEnumerable.new(
      api_call, request, response, options
    )

    assert_equal %w[foo bar baz bif], paged_enum.map(&:name)
  end
end
