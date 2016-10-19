# frozen_string_literal: true
require_relative 'fb_api'
require_relative 'feed'

module FaceGroup
  # Main class to setup a Facebook group
  class Group
    attr_reader :name

    def initialize(fb_api, data:)
      @fb_api = fb_api
      @name = data['name']
      @id = data['id']
    end

    def feed
      return @feed if @feed
      feed_data = @fb_api.group_feed(@id)
      @feed = Feed.new(@fb_api,
                       postings_data: feed_data['data'],
                       paging_data: feed_data['paging'])
    end

    def self.find(fb_api, id:)
      group_data = fb_api.group_info(id)
      new(fb_api, data: group_data)
    end
  end
end
