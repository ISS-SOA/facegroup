# frozen_string_literal: true
require 'rake/testtask'

task default: :spec

# desc 'Run specs'
# Rake::TestTask.new(name=:spec) do |t|
#   t.pattern = 'spec/*_spec.rb'
# end

namespace :api do
  desc 'generate access_token to STDOUT'
  task :access_token do
    require 'yaml'
    require_relative 'lib/fb_api'
    CREDENTIALS = YAML.load(File.read('config/credentials.yml'))
    ENV['FBAPI_CLIENT_ID'] = CREDENTIALS[:client_id]
    ENV['FBAPI_CLIENT_SECRET'] = CREDENTIALS[:client_secret]

    puts "Access Token: #{FaceGroup::FbApi.access_token}"
  end
end

desc 'run tests'
task :spec do
  sh 'ruby spec/facegroup_spec.rb'
end

desc 'delete cassette fixtures'
task :wipe do
  sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
    puts(ok ? 'Cassettes deleted' : 'No casseettes found')
  end
end

namespace :quality do
  desc 'run all quality checks'
  task all: [:rubocop, :flog, :flay]

  task :flog do
    sh 'flog lib/'
  end

  task :flay do
    sh 'flay lib/'
  end

  task :rubocop do
    sh 'rubocop'
  end
end
