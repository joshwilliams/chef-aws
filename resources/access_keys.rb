#
# Cookbook Name:: aws
# Resource:: access_keys
#
# Copyright 2012, Rob Lewis <rob@kohder.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

actions :set

attribute :key_id, :kind_of => String, :name_attribute => true
attribute :attribute_path, :kind_of => [Array, String], :default => []
attribute :attribute_mode, :kind_of => String, :equal_to => ['node_attribute', 'run_state'], :default => 'node_attribute'
attribute :attribute_access_key, :kind_of => String, :default => 'aws_access_key'
attribute :attribute_secret_access_key, :kind_of => String, :default => 'aws_secret_access_key'
attribute :aws_data_bag, :kind_of => String, :default => 'aws'

def initialize(name, run_context=nil)
  super
  @action = :set
end
