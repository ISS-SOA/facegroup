require 'rake/testtask'

task :default => [:spec]

# desc 'Run specs'
# Rake::TestTask.new(name=:spec) do |t|
#   t.pattern = 'spec/*_spec.rb'
# end

namespace :api do
  task :access_token do
    require 'yaml'
    require_relative 'lib/fb_api'
    CREDENTIALS = YAML.load(File.read('config/credentials.yml'))

    fb_api = FaceGroup::FbApi.new(
      client_id: CREDENTIALS[:client_id],
      client_secret: CREDENTIALS[:client_secret]
    )

    puts "Access Token: #{fb_api.access_token}"
  end
end

task :spec do
  sh 'ruby spec/facegroup_spec.rb'
end
