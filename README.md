*If you're a non-trainee looking for developer or configuration information,
check out the* [DEV-README][dev-readme].

---

Hello there. This repository will help us track your progress through our
training process.  Here's how to get started:

You should be looking at the [private mirror][mirror] of this repository. The
code in this repository is open-source, but we keep a private copy so that the
content of the issues that track your training progress remain private. There
should be a !["Private"][private] next to the repository name at the top of the
page.

Begin by clicking the !["Fork"][fork] button in the upper-right.  If prompted,
select *your* account as the account to fork to.

Once forking is complete, click the !["Clone or Download"][download] button and
copy the repository URL by clicking the ![clipboard][clip] icon. Open a terminal
and clone the repository.

```bash
$ git clone $(pbpaste) dev-training
$ cd dev-training
```

Next, we'll run the bootstrap script that will create your graduation
milestone and add task issues for you to complete. UMTS IT staff will be added
as "collaborators" on your copy of the repository so that we can participate
as well.

```bash
$ ./bootstrap
```

As you work on other UMTS software projects, you can flag your work
as addressing a particular training task by referring to it as e.g.
`youruser/dev-training-priv#6`

[dev-readme]: https://umts.github.io/dev-training/index.html
[mirror]: https://github.com/umts/dev-training-priv

[private]: https://raw.githubusercontent.com/umts/dev-training/master/img/private.png
[fork]: https://raw.githubusercontent.com/umts/dev-training/master/img/fork.png
[download]: https://raw.githubusercontent.com/umts/dev-training/master/img/download.png
[clip]: https://raw.githubusercontent.com/umts/dev-training/master/img/clipboard.png
