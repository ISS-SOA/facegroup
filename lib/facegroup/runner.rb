# frozen_string_literal: true

module FaceGroup
  # Executable code for file(s) in bin/ folder
  class Runner
    def self.run!(args)
      group_id = args[0] || ENV['FB_GROUP_ID']
      unless group_id
        puts 'USAGE: facegroup [group_id]'
        exit(1)
      end

      group = FaceGroup::Group.find(id: group_id)

      output_info(group)
    end

    def self.output_info(group)
      name = group.name
      separator = Array.new(group.name.length) { '-' }.join
      group_info =
        group.feed.postings.first(3).map.with_index do |post, index|
          posting_info(post, index)
        end.join

      [name, separator, group_info].join("\n")
    end

    def self.posting_info(post, index)
      [
        "#{index + 1}: ",
        message_output(post.message),
        'Attached: ' + attachment_output(post.attachment),
        "\n\n"
      ].join
    end

    def self.message_output(message)
      message ? message : '(blank)'
    end

    def self.attachment_output(attachment)
      attachment ? attachment.url.to_s : '(none)'
    end
  end
end
