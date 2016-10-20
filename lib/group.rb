# frozen_string_literal: true
require_relative 'fb_api'
require_relative 'feed'

module FaceGroup
  # Main class to setup a Facebook group
  class Group
    attr_reader :name

    def initialize(data:)
      @name = data['name']
      @id = data['id']
    end

    def feed
      return @feed if @feed
      feed_data = FaceGroup::FbApi.group_feed(@id)
      @feed = Feed.new(postings_data: feed_data['data'],
                       paging_data: feed_data['paging'])
    end

    def self.find(id:)
      group_data = FbApi.group_info(id)
      new(data: group_data)
    end
  end
end
