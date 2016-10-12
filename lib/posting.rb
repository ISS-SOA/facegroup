# frozen_string_literal: true
require_relative 'fb_api'

module FaceGroup
  # Single posting on group's feed
  class Posting
    attr_reader :id, :created_time, :updated_time, :message, :attachment

    def initialize(fb_api, data: nil)
      @fb_api = fb_api
      load_data(data)
    end

    def attachment
      return @attachment if @attachment

      attached_data = @fb_api.posting_attachments(@id)
      @attachment = { description: attached_data['description'],
                      url: attached_data['url'] }
    end

    def self.find(fb_api, id:)
      posting_data = fb_api.posting(id)
      new(fb_api, data: posting_data)
    end

    private

    def load_data(posting_data)
      @id = posting_data['id']
      @updated_time = posting_data['updated_time']
      @created_time = posting_data['created_time']
      @message = posting_data['message']
      @attachment = posting_data['attachment']
    end
  end
end
