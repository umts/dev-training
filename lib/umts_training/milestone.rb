require 'yaml'

module UMTSTraining
  class Milestone
    def initialize(local_repo, client, yaml_file)
      @yaml = yaml_file
      @client = client.client # ugh
      @repo = local_repo.github_name
    end

    def create!
      @milestone ||= @client.create_milestone(@repo, 'Training exit interview')
    end

    def create_issues!
      ::YAML.load_stream(::File.open @yaml) do |document|
        @client.create_issue @repo,
                             document.fetch('title'),
                             format_body(document['description'],
                                         document['subtasks']),
                             milestone: @milestone.number
      end
    end

    private

    def format_body(desc, subtasks)
      if subtasks
        desc + "\n\n" + format_checklist(subtasks)
      else
        desc
      end
    end

    def format_checklist(checklist)
      checklist.map do |item|
        "* [ ] #{item}"
      end.join("\n")
    end
  end
end
