#
# Cookbook Name:: hbase
# Library:: hbase_search 
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

module HbaseSearch

	def hbase_search(role, limit = 1000)

		query =  "chef_environment:#{node.chef_environment}"
		query << " AND roles:#{role}"
		query << " hbase_cluster_name:#{node[:hbase][:cluster_name]}"

		results = Array.new
		search(:node, query).each do |n|
			results << n[:fqdn]
		end

		if (results.length == 0 || results.length > limit)
			log("hbase_search: #{role}: nodes found: #{results.length}") { level :error }
		end

		Chef::Log.debug "hbase_search: #{role}: nodes found: #{results.length}"

		results.length == 1 ? results.first : results

	end

end

class Chef::Recipe; include HbaseSearch; end
