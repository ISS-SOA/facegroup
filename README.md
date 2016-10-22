# FaceGroup Gem

[![Build Status](https://travis-ci.org/ISS-SOA/facegroup.svg?branch=master)](https://travis-ci.org/ISS-SOA/facegroup)

FaceGroup is a gem that specializes in getting data from public Facebook Groups.

## Installation

If you are working on a project, add this to your Gemfile: `gem 'facegroup'`

For ad hoc installation from command line:

```$ gem install facegroup```

## Setup Facebook Credentials

Please setup your Facebook developer credentials by creating an app profile on Facebook Developer: https://developers.facebook.com – you should get a "client ID" and "client secret".

## Usage

Require FaceGroup gem in your code: `require 'facegroup'`

Supply your Facebook credentials to our library in one of two ways:
- Setup environment variables: `ENV[FB_CLIENT_ID]` and `ENV[FB_CLIENT_SECRET]`
- or, provide them directly to FaceGroup:

```
FaceGroup::FbApi.config = { client_id: ENV['FB_CLIENT_ID'],
                            client_secret: ENV['FB_CLIENT_SECRET'] }
```

See the following example code for more usage details:

```ruby
# Access the group
group = FaceGroup::Group.find(
  id: ENV['FB_GROUP_ID']
)

puts group.name

feed = group.feed

puts feed.count

group.feed.postings.each do |posting|
  puts posting.id
  puts posting.created_time
  puts posting.message
  if posting.attachment
    puts posting.attachment.description
    puts posting.attachment.url
  end
end
```
