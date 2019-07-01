# frozen_string_literal: true

module UMTSTraining
  ##
  # A few helpers for formatting issue text. Available as module functions
  # for convenience, but also included in UMTSTraining::Milestone
  module FormattingHelpers
    module_function

    ##
    # Returns `desc`, and optionally if `subtasks` is a non-empty `Array`, the
    # results of format_checklist tacked on after a blank line.
    def format_body(desc, subtasks = [])
      return desc if subtasks.nil? || subtasks.empty?

      [desc, format_checklist(subtasks)].compact.join "\n\n"
    end

    ##
    # Makes a GFM "tasklisk" with one item per item in `checklist`
    def format_checklist(checklist)
      checklist.map do |item|
        "* [ ] #{item}"
      end.join("\n")
    end
  end
end
