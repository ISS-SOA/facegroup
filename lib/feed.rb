# frozen_string_literal: true
require_relative 'fb_api'
require_relative 'posting'

module FaceGroup
  # Group feeds, with data and paging information
  class Feed
    attr_reader :postings

    def initialize(fb_api, postings_data:, paging_data:)
      @fb_api = fb_api
      @postings = postings_data.map do |post_data|
        FaceGroup::Posting.new(@fb_api, data: post_data)
      end

      @paging = paging_data
    end

    def count
      @postings.count
    end
  end
end
