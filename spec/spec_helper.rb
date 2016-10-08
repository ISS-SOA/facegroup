# frozen_string_literal: true
require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'

require './lib/fb_api'
require './lib/group.rb'
require './lib/posting.rb'

# require 'webmock/minitest'

require 'webmock'
include WebMock::API
WebMock.enable!

CREDENTIALS = YAML.load(File.read('config/credentials.yml'))
FB_RESPONSE = YAML.load(File.read('spec/fixtures/fb_response.yml'))
FB_RESULT = YAML.load(File.read('spec/fixtures/fb_result.yml'))

stub_request(:get, FaceGroup::FbApi::FB_TOKEN_URL).with(
  query: { 'client_id' => CREDENTIALS[:client_id],
           'client_secret' => CREDENTIALS[:client_secret],
           'grant_type' => 'client_credentials' }
).to_return(
  status: FB_RESPONSE[:access_token].status.to_i,
  headers: FB_RESPONSE[:access_token].headers,
  body: FB_RESPONSE[:access_token].body.to_s
)

group_url = URI.join(FaceGroup::FbApi::FB_API_URL, CREDENTIALS[:group_id].to_s)
stub_request(:get, group_url).with(
  query: { 'access_token' => FB_RESULT[:access_token] }
).to_return(
  status: FB_RESPONSE[:group].status.to_i,
  headers: FB_RESPONSE[:group].headers,
  body: FB_RESPONSE[:group].body.to_s
)

feed_url = group_url.to_s + '/feed'
stub_request(:get, feed_url).with(
  query: { 'access_token' => FB_RESULT[:access_token] }
).to_return(
  status: FB_RESPONSE[:feed].status.to_i,
  headers: FB_RESPONSE[:feed].headers,
  body: FB_RESPONSE[:feed].body.to_s
)

posting_id = FB_RESULT[:posting]['id']
attachment_url = URI.join(FaceGroup::FbApi::FB_API_URL,
                          "#{posting_id}/attachments")
stub_request(:get, attachment_url).with(
  query: { 'access_token' => FB_RESULT[:access_token] }
).to_return(
  status: FB_RESPONSE[:attachment].status.to_i,
  headers: FB_RESPONSE[:attachment].headers,
  body: FB_RESPONSE[:attachment].body.to_s
)
