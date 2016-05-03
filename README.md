*If you're a non-trainee looking for developer or configuration information,
check out the [DEV-README][0].*

---

Hello there. This repository will help us track your progress through our
training progress.  Here's how to get started:

You should be looking at the [private mirror][1] of this repository. The code
in this repository is open-source, but we keep a private copy so that the
content of the issues that track your training progress remain private. There
should be a ![PRIVATE][2] next to the repository name at the top of the page.

Begin by clicking the "Fork" button in the upper-right.  If prompted, select
your account as the account to fork to.

Once forking is complete, copy the repository URL by clicking the
![clipboard][3] icon. Open a terminal and clone the repository.

```bash
$ git clone --depth 1 $(pbpaste) dev-training
$ cd dev-training
```

Next you'll need a few Ruby gems in order to interact with GitHub. We'll use
Bundler to install them.

```bash
$ bundle --without=test
```

Finally, we'll run the bootstrap script that will create your Graduation
milestone and add task issues for you to complete. UMTS IT staff will be added
as "collaborators" on your copy of the repository so we can participate
as well.

```bash
$ ./bootsrap
```

As you work on other UMTS software projects, you can flag your work
as addressing a particular training task by referring to it as e.g.
`youruser/dev-training-priv#6`

[0]: https://github.com/umts/dev-training/blob/master/DEV-README.md
[1]: https://github.com/umts/dev-training-priv
[2]: https://github.com/umts/dev-training/raw/master/private.png
[3]: https://github.com/umts/dev-training/raw/master/clipboard.png
