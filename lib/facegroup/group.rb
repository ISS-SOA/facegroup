# frozen_string_literal: true
require_relative 'fb_api'
require_relative 'feed'

module FaceGroup
  # Main class to setup a Facebook group
  class Group
    attr_reader :id, :name, :feed

    def initialize(group_data:)
      @name = group_data['name']
      @id = group_data['id']
      @feed = Feed.new(feed_data: group_data['feed'])
    end

    def self.find(id:)
      group_data = FbApi.group_data(id)
      group_data.include?('error') ? nil : new(group_data: group_data)
    end

    def self.latest_postings(id:)
      FbApi.newest_group_postings(id)
    end
  end
end
