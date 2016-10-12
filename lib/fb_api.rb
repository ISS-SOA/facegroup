# frozen_string_literal: true
require 'http'

module FaceGroup
  # Service for all FB API calls
  class FbApi
    FB_URL = 'https://graph.facebook.com'
    API_VER = 'v2.8'
    FB_API_URL = URI.join(FB_URL, "#{API_VER}/")
    FB_TOKEN_URL = URI.join(FB_API_URL, 'oauth/access_token')

    attr_accessor :access_token

    def initialize(client_id: nil, client_secret: nil, access_token: nil)
      if access_token
        @access_token = access_token
      else
        access_token_response =
          HTTP.get(FB_TOKEN_URL,
                   params: { client_id: client_id,
                             client_secret: client_secret,
                             grant_type: 'client_credentials' })
        @access_token = JSON.load(access_token_response.to_s)['access_token']
      end
    end

    def group_info(group_id)
      group_response = HTTP.get(fb_resource_url(group_id),
                                params: { access_token: @access_token })
      JSON.load(group_response.to_s)
    end

    def group_feed(group_id)
      feed_response = HTTP.get(
        fb_resource_url(group_id).to_s + '/feed',
        params: { access_token: @access_token }
      )
      JSON.load(feed_response.to_s)['data']
    end

    def posting(posting_id)
      feed_response = HTTP.get(
        fb_resource_url(posting_id).to_s,
        params: { access_token: @access_token }
      )

      JSON.load(feed_response.to_s)
    end

    def posting_attachments(posting_id)
      attachments_response = HTTP.get(
        fb_resource_url(posting_id).to_s + '/attachments',
        params: { access_token: @access_token }
      )
      JSON.load(attachments_response.to_s)['data'].first
    end

    private

    def fb_resource_url(id)
      URI.join(FB_API_URL, id.to_s)
    end
  end
end
