This repository is used to track our programmer Trainees' progress through
training.  It uses [Octokit][1] at the command-line to create issues
for each of the tasks that we think a programmer trainee should complete
before graduating to full-fledged developer.

Configuring Training Issues
---------------------------
The issues that will be created to track a trainee's progress come from
`qualifications.yml`. Each one is a YAML "document" and looks like this

```yaml
---
title: 'Issue title'
description: >
  A longer description of the task. You can put markdown in here
  since GitHub will be rendering it. This field is optional.
subtasks:
  - 'Optional'
  - 'Array of subtasks'
  - 'That will be rendered'
  - 'as a task list'
```

Collaborators
-------------
The list of users that will be added as collaborators is defined in the
`colaborators.yml` file. It isn't possible, unfortunately, to use the API to
get those users, since listing team membership isn't a thing a regular
organization member can do.

Configuring messages used by `bootstrap`
-------------------------------------
The texts of messages that the CLI displays while it's running are in
`messages.yml`. Each message is a YAML "mapping". The value of the message
will be passed to [`Highline#say`][2] so you can use ERb tags and the
various Highline helper methods (like `color`).

Updating the private copy
-------------------------
You can consider the private mirror the "production" copy of this code. It's
what new developer trainees will use when they start training.  Add it as a
remote on your local copy.

```bash
$ git remote add prod git@github.com:umts/dev-training-priv.git
```

Now, you can push to it just like you would to master

```bash
$ git push prod master
```

[1]: https://github.com/octokit/octokit.rb
[2]: http://www.rubydoc.info/github/JEG2/highline/master/HighLine#say-instance_method
