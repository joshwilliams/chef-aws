#
# Cookbook Name:: aws-encrypted
# Recipe:: default
#

include_recipe 'aws'

# Manage AWS access keys as requested via node attributes (done immediately)
aws_access_keys_entries = node['aws']['access_keys']
unless aws_access_keys_entries.nil?
  aws_access_keys_entries.each do |name, attributes|
    act = if attributes.include? 'action'
      attributes['action']
    else
      :set
    end

    aws_keys_access_keys name do
      attributes.each do |k, v|
        self.send(k.to_sym, v)
      end
      action :nothing
    end.run_action(act)
  end
end
