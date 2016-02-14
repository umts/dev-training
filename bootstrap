#!/usr/bin/env ruby
this_dir = File.dirname(__FILE__)

$LOAD_PATH.unshift File.join(this_dir, 'lib')
require 'umts_training'

local_repo = UMTSTraining::LocalRepo.new this_dir
cli = UMTSTraining::CLI.new
client = UMTSTraining::Client.new local_repo, cli
milestone = UMTSTraining::Milestone.new local_repo,
                                        client,
                                        'qualifications.yml'

client.add_collaborators! %w(werebus sherson dfaulken)
milestone.create!
milestone.create_issues!
