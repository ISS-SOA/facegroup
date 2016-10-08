# frozen_string_literal: true
require 'json'
require 'yaml'
require 'http'
require_relative '../lib/fb_api'

CREDENTIALS = YAML.load(File.read('config/credentials.yml'))

FB_API_URL = FaceGroup::FbApi::FB_API_URL
FB_TOKEN_URL = FaceGroup::FbApi::FB_TOKEN_URL

fb_response = {}
fb_result = {}

# Record access token response and result
access_token_response = HTTP.get(
  FB_TOKEN_URL,
  params: { client_id: CREDENTIALS[:client_id],
            client_secret: CREDENTIALS[:client_secret],
            grant_type: 'client_credentials' }
)
fb_response[:access_token] = access_token_response
access_token_data = JSON.load(access_token_response.to_s)
access_token = access_token_data['access_token']
fb_result[:access_token] = access_token

# Record group information response and result
group_response = HTTP.get(
  URI.join(FB_API_URL, "/#{CREDENTIALS[:group_id]}/"),
  params: { access_token: access_token }
)
fb_response[:group] = group_response
group_results = JSON.load(group_response.body.to_s)
fb_result[:group] = group_results

# Record group feed response and result
feed_response = HTTP.get(
  URI.join(FB_API_URL, "/#{CREDENTIALS[:group_id]}/feed"),
  params: { access_token: access_token }
)
fb_response[:feed] = feed_response
feed = JSON.load(feed_response)['data']
fb_result[:feed] = feed

# Record id of feed postings with messages
posting_with_message_id = feed.find { |p| p['message'] }['id']
fb_result[:posting_with_message_id] = posting_with_message_id

# Record posting response and result
posting_response = HTTP.get(
  URI.join(FB_API_URL, "/#{posting_with_message_id}"),
  params: { access_token: access_token }
)
fb_response[:posting] = posting_response
posting = JSON.load(posting_response)
fb_result[:posting] = posting

# Record posting attachment response and result
attachment_response = HTTP.get(
  URI.join(FB_API_URL, "/#{posting_with_message_id}/attachments"),
  params: { access_token: access_token }
)
fb_response[:attachment] = attachment_response
attachment = JSON.load(attachment_response)['data']
fb_result[:attachment] = attachment

File.write('spec/fixtures/fb_response.yml', fb_response.to_yaml)
File.write('spec/fixtures/fb_result.yml', fb_result.to_yaml)
