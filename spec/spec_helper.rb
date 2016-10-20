# frozen_string_literal: true
require 'simplecov'
SimpleCov.start

require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/facegroup'

FIXTURES_FOLDER = 'spec/fixtures'
CASSETTES_FOLDER = "#{FIXTURES_FOLDER}/cassettes"
CASSETTE_FILE = 'facebook_api'
CREDENTIALS = YAML.load(File.read('config/credentials.yml'))
ENV['FB_CLIENT_ID'] = CREDENTIALS[:client_id]
ENV['FB_CLIENT_SECRET'] = CREDENTIALS[:client_secret]

RESULT_FILE = "#{FIXTURES_FOLDER}/fb_api_results.yml"
FB_RESULT = YAML.load(File.read(RESULT_FILE))
