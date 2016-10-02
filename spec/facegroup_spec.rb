# frozen_string_literal: true
require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'

require './lib/group.rb'

CREDENTIALS = YAML.load(File.read('config/credentials.yml'))
FB_RESPONSE = YAML.load(File.read('spec/fixtures/fb_response.yml'))
RESULTS = YAML.load(File.read('spec/fixtures/results.yml'))

describe 'FaceGroup specifications' do
  before do
    @fb_api = FaceGroup::FbApi.new(
      client_id: CREDENTIALS[:client_id],
      client_secret: CREDENTIALS[:client_secret]
    )
  end

  it 'should be able to open a Facebook Group' do
    group = FaceGroup::Group.new(
      @fb_api,
      group_id: CREDENTIALS[:group_id]
    )

    group.name.length.must_be :>, 0
  end

  it 'should get the latest feed from an group' do
    group = FaceGroup::Group.new(
      @fb_api,
      group_id: CREDENTIALS[:group_id]
    )

    feed = group.feed
    feed.count.must_be :>, 10
  end

  it 'should get information about postings on the feed' do
    group = FaceGroup::Group.new(
      @fb_api, group_id: CREDENTIALS[:group_id]
    )

    posting = group.feed.first
    posting.message.length.must_be :>, 0
  end

  it 'should find attachments in postings' do
    group = FaceGroup::Group.new(
      @fb_api, group_id: CREDENTIALS[:group_id]
    )

    posting = group.feed.first
    posting.attachment[:description].length.must_be :>, 0
  end
end
