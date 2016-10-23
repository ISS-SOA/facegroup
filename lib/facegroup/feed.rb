# frozen_string_literal: true
require_relative 'fb_api'
require_relative 'posting'

module FaceGroup
  # Group feeds, with data and paging information
  class Feed
    attr_reader :postings

    def initialize(feed_data:)
      postings_data = feed_data['data']
      @postings = postings_data.map do |post_data|
        FaceGroup::Posting.new(data: post_data)
      end

      @pagination = feed_data['pagination']
    end

    def count
      @postings.count
    end
  end
end
