# frozen_string_literal: true
require_relative 'fb_api'
require_relative 'posting'

module FaceGroup
  # Group feeds, with data and paging information
  class Feed
    attr_reader :postings

    def initialize(postings_data:, paging_data:)
      @postings = postings_data.map do |post_data|
        FaceGroup::Posting.new(data: post_data)
      end

      @paging = paging_data
    end

    def count
      @postings.count
    end
  end
end
