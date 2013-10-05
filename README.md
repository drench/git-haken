# Haken: Git Hooks Reworked

For those of us who like git hooks, but not managing them.

## To install:

    git clone git://github.com/drench/git-haken.git ~/.git-haken
    git config --global init.templatedir ~/.git-haken/templates

From then on, any git repositories you create or clone will use this exciting
alternate template and the hooks it contains.

## To upgrade a tree you've already checked out:

    cd some/boring/old/repo
    git init

## Haken comes with a few hooks that I've found useful:

* One prevents you from committing trailing whitespace
* One restarts pow on checkout, if this is a Rails project using pow
* One handles local `user.name` and `user.email` configuration overrides
(read `.git_template/hooks/post-checkout.d/100-local-config-overrides-on-clone.rb`
for a better description of what this does)
* One inserts a ticket number into your commit message template if your branch
name looks like it contains a ticket number

These hooks live under `.git_template/hooks` in 17 subdirectories, one for
each hook type: post-checkout hooks live under `.git_template/hooks/post-checkout.d/`,
pre-commit hooks go in `.git_template/hooks/pre-commit.d/`, etc.

Unlike standard git hooks, where there is just one script per hook type,
you can have as many scripts as you like for each type. If you want 15
pre-commit hooks, it's kind of excessive, but I won't stop you.

(See `git help hooks` for the circumstances git runs each hook type.)

To disable a hook, remove its execute bit, or just delete the file.
For example, if you don't find the `pow` hook useful, turn it off:

    chmod -x .git_template/hooks/post-checkout.d/500-restart-pow.sh

## Add your own!

You are a git user and I expect you to fork.

Write a hook in whatever language you like. Most hooks I've seen are shell
or Perl scripts, but you could use just about anything: Ruby, Python, Node.js,
PHP, even a binary compiled from C if that's what you're into.

## License

MIT-style