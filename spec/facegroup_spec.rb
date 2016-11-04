# frozen_string_literal: true
require_relative 'spec_helper.rb'

describe 'FaceGroup specifications' do
  before do
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'FbApi Credentials' do
    it '(HAPPY) should get new access token with ENV credentials' do
      FaceGroup::FbApi.access_token.length.must_be :>, 0
    end

    it '(HAPPY) should get new access token with file credentials' do
      FaceGroup::FbApi.config = { client_id: ENV['FB_CLIENT_ID'],
                                  client_secret: ENV['FB_CLIENT_SECRET'] }
      FaceGroup::FbApi.access_token.length.must_be :>, 0
    end
  end

  describe 'Finding Group Information' do
    describe 'Find a Group' do
      it '(HAPPY) should be able to find a Facebook Group with proper ID' do
        group = FaceGroup::Group.find(id: ENV['FB_GROUP_ID'])

        group.name.length.must_be :>, 0
      end

      it '(SAD) should return nil if Group ID is invalid' do
        group = FaceGroup::Group.find(id: INVALID_RESOURCE_ID)
        group.must_be_nil
      end
    end

    describe 'Retrieving Group Feed' do
      it '(HAPPY) should get the latest feed from an group with proper ID' do
        group = FaceGroup::Group.find(id: ENV['FB_GROUP_ID'])

        feed = group.feed
        feed.count.must_be :>, 1
      end

      it '(HAPPY) should get the postings on the feed with proper ID' do
        group = FaceGroup::Group.find(id: ENV['FB_GROUP_ID'])

        group.feed.postings.each do |posting|
          posting.id.wont_be_nil
          posting.updated_time.wont_be_nil
        end
      end
    end
  end

  describe 'Finding Posting Information' do
    it '(HAPPPY) should find all parts of a full posting' do
      posting = FB_RESULT['posting']
      attachment = posting['attachment'].first
      retrieved = FaceGroup::Posting.find(id: posting['id'])

      retrieved.id.must_equal posting['id']
      retrieved.created_time.must_equal posting['created_time']
      retrieved.message.must_equal posting['message']
      retrieved.attachment.wont_be_nil
      retrieved.attachment.description.must_equal attachment['description']
      retrieved.attachment.url.must_match 'tutorialzine'
    end

    it '(SAD) should return nil if Posting ID is invalid' do
      posting = FaceGroup::Posting.find(id: INVALID_RESOURCE_ID)
      posting.must_be_nil
    end
  end

  describe 'Command Line Executable Actions' do
    it 'should run the executable file' do
      output = FaceGroup::Runner.run!([ENV['FB_GROUP_ID']])
      output.split("\n").length.must_be :>, 5
    end
  end
end
