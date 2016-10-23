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
      group:   'id,name,feed{name,message,updated_time,created_time,'\
               'attachments{title,description,url,media}}',
      posting: 'name,message,updated_time,created_time,'\
               'attachments{title,description,url,media}'
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

    def self.group_data(group_id)
      graphql_query(group_id, :group)
    end

    def self.posting_data(posting_id)
      graphql_query(posting_id, :posting)
    end

    def self.graphql_query(resource_id, resource_key)
      response = HTTP.get(
        fb_resource_url(resource_id),
        params: { fields: GRAPH_QUERY[resource_key],
                  access_token: access_token }
      )
      JSON.load(response.to_s)
    end

    private_class_method

    def self.fb_resource_url(id)
      URI.join(FB_API_URL, id.to_s).to_s
    end
  end
end
