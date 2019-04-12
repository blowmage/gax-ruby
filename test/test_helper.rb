# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'simplecov'
if ENV['CI'] == 'true' || ENV['CODECOV_TOKEN']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
SimpleCov.start

gem 'minitest'
require 'minitest/autorun'
require 'minitest/focus'
require 'minitest/rg'

require 'google/gax'
require 'google/protobuf/any_pb'
require_relative './fixtures/fixture_pb'

class CodeError < StandardError
  attr_reader :code

  def initialize(msg, code)
    super(msg)
    @code = code
  end
end

class NonCodeError < StandardError
end

FAKE_STATUS_CODE_1 = 101
FAKE_STATUS_CODE_2 = 102

class OperationStub
  def initialize(&block)
    @block = block
  end

  def execute
    @block.call
  end
end
