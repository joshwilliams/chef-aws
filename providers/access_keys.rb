#
# Cookbook Name:: aws
# Provider:: access_keys
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

require 'chef/mixin/deep_merge'

def load_current_resource
  aws_data_bag_name = new_resource.aws_data_bag
  aws_data_bag = data_bag(aws_data_bag_name)
  if aws_data_bag.nil?
    Chef::Log.info("AWS data bag '#{aws_data_bag_name}' not found.")
  end
  @access_keys = load_access_keys(aws_data_bag_name)
end

action :set do
  access_key_entry = @access_keys[new_resource.key_id]
  if access_key_entry.nil?
    Chef::Log.error("No AWS access key found for '#{new_resource.key_id}'.")
  else
    attr_map = new_resource.attribute_mode == 'run_state' ? node.run_state : node.normal
    Array(new_resource.attribute_path).each do |attr_path_element|
      unless attr_map.has_key?(attr_path_element)
        attr_map[attr_path_element] = {}
      end
      attr_map[attr_path_element][new_resource.attribute_access_key] = access_key_entry['access_key']
      attr_map[attr_path_element][new_resource.attribute_secret_access_key] = access_key_entry['secret_access_key']
    end
    Chef::Log.info("AWS access keys '#{new_resource.key_id}' set.")
  end
  nil
end

private

def load_access_keys(aws_data_bag)
  access_keys_data_bag_item = data_bag_item(aws_data_bag, 'access_keys')
  secret_access_keys_data_bag_item = Chef::EncryptedDataBagItem.load(aws_data_bag, 'secret_access_keys')
  access_keys_hash = hash_from_data_bags(access_keys_data_bag_item, secret_access_keys_data_bag_item)
  access_keys_hash['keys'] || {}
end

def hash_from_data_bags(access_keys_data_bag_item, secret_access_keys_data_bag_item)
  current_environment = node.chef_environment
  access_keys_hash = collapse_environment_overrides(access_keys_data_bag_item.to_hash, current_environment)
  unless secret_access_keys_data_bag_item.nil?
    secret_access_keys_hash = collapse_environment_overrides(secret_access_keys_data_bag_item.to_hash, current_environment)
    access_keys_hash = Chef::Mixin::DeepMerge.merge(access_keys_hash, secret_access_keys_hash)
  end
  access_keys_hash
end

def collapse_environment_overrides(data_bag_hash, current_environment)
  if (environments_hash = data_bag_hash.delete('environments')) &&
     (environment_hash = environments_hash[current_environment])
    data_bag_hash = Chef::Mixin::DeepMerge.merge(data_bag_hash, environment_hash)
  end
  data_bag_hash
end
