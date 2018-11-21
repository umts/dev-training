require 'bundler'
Bundler.require(:default)

require 'umts_training/cli'
require 'umts_training/client'
require 'umts_training/local_repo'
require 'umts_training/milestone'

module UMTSTraining
  def self.collaborators
    # Sadly getting members of a team via the API requires a level of
    # permission on the organization that our trainees won't have.
    %w(werebus sherson Anbranin)
  end
end
