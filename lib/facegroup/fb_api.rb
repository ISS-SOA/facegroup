# frozen_string_literal: true
require 'http'

module FaceGroup
  # Service for all FB API calls
  class FbApi
    FB_URL = 'https://graph.facebook.com'
    API_VER = 'v2.8'
    FB_API_URL = [FB_URL, API_VER].join('/')
    FB_TOKEN_URL = [FB_API_URL, 'oauth/access_token'].join('/')
    TOKEN_KEY = 'fbapi_access_token'

    GRAPH_QUERY = {
      feed: 'feed{name,message,updated_time,created_time,'\
            'attachments{title,url,media}}'
    }.freeze

    def self.access_token
      return @access_token if @access_token

      access_token_response =
        HTTP.get(FB_TOKEN_URL,
                 params: { client_id: config[:client_id],
                           client_secret: config[:client_secret],
                           grant_type: 'client_credentials' })
      @access_token = access_token_response.parse['access_token']
    end

    def self.config=(credentials)
      @config ? @config.update(credentials) : @config = credentials
    end

    def self.config
      return @config if @config
      @config = { client_id:     ENV['FB_CLIENT_ID'],
                  client_secret: ENV['FB_CLIENT_SECRET'] }
    end

    def self.group_feed(group_id)
      feed_response = HTTP.get(
        fb_resource_url(group_id),
        params: { fields: GRAPH_QUERY[:feed],
                  access_token: @access_token }
      )
      feed_data = JSON.load(feed_response.to_s)['feed']

      { 'postings' => feed_data['data'],
        'pagination' => feed_data['pagination'] }
    end

    def self.group_info(group_id)
      fb_resource(group_id)
    end

    def self.posting(posting_id)
      fb_resource(posting_id)
    end

    def self.posting_attachments(posting_id)
      attachments_response = HTTP.get(
        fb_resource_url(posting_id) + '/attachments',
        params: { access_token: access_token }
      )
      JSON.load(attachments_response.to_s)['data'].first
    end

    private_class_method

    def self.fb_resource_url(id)
      URI.join(FB_API_URL, id.to_s).to_s
    end

    def self.fb_resource(id)
      response = HTTP.get(
        fb_resource_url(id),
        params: { access_token: access_token }
      )
      JSON.load(response.to_s)
    end
  end
end
