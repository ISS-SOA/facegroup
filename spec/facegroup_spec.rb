# frozen_string_literal: true
require_relative 'spec_helper.rb'

describe 'FaceGroup specifications' do
  before do
    @fb_api = FaceGroup::FbApi.new(
      client_id: CREDENTIALS[:client_id],
      client_secret: CREDENTIALS[:client_secret]
    )

    @posting_with_msg_id = FB_RESULT[:posting_with_message_id].first
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

    posting_with_msg = group.feed.find { |p| p.id == @posting_with_msg_id}
    posting_with_msg.message.length.must_be :>, 0
  end

  it 'should find attachments in postings' do
    group = FaceGroup::Group.new(
      @fb_api, group_id: CREDENTIALS[:group_id]
    )

    posting_with_msg = group.feed.find { |p| p.id == @posting_with_msg_id}
    posting_with_msg.attachment[:description].length.must_be :>, 0
  end
end
