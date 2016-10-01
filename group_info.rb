require 'yaml'
require 'http'

# Create a API response dump
credentials = YAML.load(File.read('credentials.yml'))
fb_response = {}
results = {}

# Initialize API connection by getting access_token
#  require client_id and client_secret
access_token_response =
  HTTP.get('https://graph.facebook.com/oauth/access_token',
           params: { client_id: credentials[:client_id],
                     client_secret: credentials[:client_secret],
                     grant_type: 'client_credentials' })
fb_response[:access_token] = access_token_response
access_token = access_token_response.body.to_s.split('=').last
results[:access_token] = access_token

# Find desired group:
#  requires group_id: use 3rd party site or parse FB group page (problem)
group_id = '150352985174571'
group_response = HTTP.get("https://graph.facebook.com/v2.7/#{group_id}",
                          params: { access_token: access_token })
fb_response[:group] = group_response
group = JSON.load(group_response.to_s)
results[:group] = group

# Get feed from group's page
#  requires group_id (see above), access token
feed_response = HTTP.get("https://graph.facebook.com/v2.7/#{group_id}/feed",
                         params: { access_token: access_token })
fb_response[:feed] = feed_response
feed = JSON.load(feed_response.to_s)['data']
results[:feed] = feed

# Get particular posting from feed (minimum useful information)
#  requires: posting_num, feed (array)
posting_num = 0
posting_data = feed[posting_num]
attachments_response =
  HTTP.get("https://graph.facebook.com/v2.7/#{posting_data['id']}/attachments",
           params: { access_token: access_token })
fb_response[:attachments] = attachments_response
attachment = JSON.load(attachments_response.to_s)
results[:attachement] = attachment
attached_data = attachment['data'].first
attached_info = { description: attached_data['description'],
                  url: attached_data['url'] }
posting = { body: posting_data['message'],
            attached: attached_info }
results[:posting] = posting

File.write('fb_response.yml', fb_response.to_yaml)
File.write('results.yml', results.to_yaml)
