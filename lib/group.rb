# frozen_string_literal: true
require_relative 'fb_api'
require_relative 'posting'

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
      raw_feed = @fb_api.group_feed(@id)
      @feed = raw_feed.map do |posting|
        FaceGroup::Posting.new(@fb_api, data: posting)
      end
    end

    def self.find(fb_api, id:)
      group_data = fb_api.group_info(id)
      new(fb_api, data: group_data)
    end
  end
end
