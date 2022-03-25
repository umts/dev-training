Archived
--------
Due to changes in GitHub's auth APIs (see
https://github.com/umts/dev-training/issues/35), we elected to make a small
web-based application to replace the CLI method used in this project. That
project can be found at:

https://github.com/umts/dev-training-web

---

This repository is used to track our programmer Trainees' progress through
training.  It uses [Octokit][ok] at the command-line to create issues
for each of the tasks that we think a programmer trainee should complete
before graduating to full-fledged developer.

Configuring Training Issues
---------------------------
The issues that will be created to track a trainee's progress come from
`config/qualifications.yml`. Each one is a YAML "document" and looks like this

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
The list of users and/or teams that will be added as collaborators is defined
in the `config/colaborators.yml` file. It can either be just a list of GitHub
usernames:

```yaml
---
- able
- baker
- charlie
```

or a mapping with a list of teams and a list of users:

```yaml
---
teams:
  - BestProgrammers
users:
  - someOtherProgrammer
```

Configuring messages used by `bootstrap`
-------------------------------------
The texts of messages that the CLI displays while it's running are in
`config/messages.yml`. Each message is a YAML "mapping". The value of the
message will be passed to [`Highline#say`][hl] so you can use ERB tags and the
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

[ok]: https://github.com/octokit/octokit.rb
[hl]: http://www.rubydoc.info/github/JEG2/highline/master/HighLine#say-instance_method
[travis]: https://travis-ci.org/umts/dev-training
[travis-badge]: https://travis-ci.org/umts/dev-training.svg?branch=master
