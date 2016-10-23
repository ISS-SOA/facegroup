# frozen_string_literal: true

module FaceGroup
  # Attached URL to Posting
  class Attachment
    attr_reader :title, :description, :url

    def initialize(data)
      return unless data
      attachment_data = data['data'].first
      @title = attachment_data['title']
      @description = attachment_data['description']
      @url = attachment_data['url']
    end
  end
end
