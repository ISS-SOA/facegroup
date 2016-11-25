# frozen_string_literal: true

module FaceGroup
  # Attached URL to Posting
  class Attachment
    attr_reader :title, :description, :url, :media_url

    def initialize(data)
      return unless data
      attachment_data = data['data'].first
      @title = attachment_data['title']
      @description = attachment_data['description']
      @url = attachment_data['url']
      @media_url = attachment_data&.[]('media')&.[]('image')&.[]('src')
    end
  end
end
