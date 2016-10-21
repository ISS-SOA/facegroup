# frozen_string_literal: true
require_relative 'fb_api'
require_relative 'attachment'

module FaceGroup
  # Single posting on group's feed
  class Posting
    attr_reader :id, :created_time, :updated_time, :message, :name

    def initialize(data: nil)
      load_data(data)
    end

    def attachment
      return @attachment if @attachment

      attached_data = FaceGroup::FbApi.posting_attachments(@id)
      @attachment = Attachment.new(attached_data)
    end

    def self.find(id:)
      posting_data = FaceGroup::FbApi.posting(id)
      new(data: posting_data)
    end

    private

    def load_data(posting_data)
      @id = posting_data['id']
      @updated_time = posting_data['updated_time']
      @created_time = posting_data['created_time']
      @name = posting_data['message']
      @message = posting_data['message']
      attached = posting_data['attachment']
      @attachment = Attachment.new(attached) if attached
    end
  end
end
