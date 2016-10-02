# frozen_string_literal: true
require_relative 'fb_api'

module FaceGroup
  # Single posting on group's feed
  class Posting
    attr_reader :message, :updated_at, :id, :attachment

    def initialize(fb_api, id:, message:, updated_at:)
      @fb_api = fb_api
      @id = id
      @message = message
      @updated_at = updated_at
    end

    def attachment
      return @attachment if @attachment

      attached_data = @fb_api.posting_attachments(@id)
      @attachment = { description: attached_data['description'],
                      url: attached_data['url'] }
    end
  end
end
