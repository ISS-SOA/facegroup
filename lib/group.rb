# frozen_string_literal: true
require 'http'
require_relative 'posting'

module FaceGroup
  # Main class to setup a Facebook group
  class Group
    attr_reader :access_token, :name

    def initialize(client_id:, client_secret:, group_id:)
      # Initialize API connection by getting access_token
      #  require client_id and client_secret
      access_token_response =
        HTTP.get('https://graph.facebook.com/oauth/access_token',
                 params: { client_id: client_id,
                           client_secret: client_secret,
                           grant_type: 'client_credentials' })
      @access_token = access_token_response.body.to_s.split('=').last

      # Find desired group:
      #  requires group_id: use 3rd party site or parse FB group page (problem)
      group_response = HTTP.get("https://graph.facebook.com/v2.7/#{group_id}",
                                params: { access_token: @access_token })
      group = JSON.load(group_response.to_s)
      @name = group['name']
      @id = group['id']
    end

    def feed
      return @feed if @feed

      feed_response = HTTP.get("https://graph.facebook.com/v2.7/#{@id}/feed",
                               params: { access_token: @access_token })
      raw_feed = JSON.load(feed_response.to_s)['data']
      @feed = raw_feed.map do |p|
        FaceGroup::Posting.new(
          @access_token, p['id'], p['message'], p['updated_time']
        )
      end
    end
  end
end
