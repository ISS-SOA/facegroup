# frozen_string_literal: true
require_relative 'fb_api'
require_relative 'posting'

module FaceGroup
  # Main class to setup a Facebook group
  class Group
    attr_reader :name

    def initialize(fb_api, group_id:)
      @fb_api = fb_api
      group = @fb_api.group_info(group_id)
      @name = group['name']
      @id = group['id']
    end

    def feed
      return @feed if @feed
      raw_feed = @fb_api.group_feed(@id)
      @feed = raw_feed.map do |p|
        FaceGroup::Posting.new(
          @fb_api,
          id: p['id'], message: p['message'], updated_at: p['updated_time']
        )
      end
    end
  end
end
