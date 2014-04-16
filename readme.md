**dotbox**, because the world ~~didn't~~ need another dotfile manager.

Just a project done for fun, not due to a particular dislike of other implementations or idea that this would be any better.

## Scenario

You work on multiple machines and want to make sure that your dotfiles are easily synced between them.


## Use

First you need to have ruby 1.9.3+ installed, preferably with rvm.



## Setup a project

First create a dropbox project, we'll treat this just like any other ruby app -- except we'll place it at `~/.dotbox`.

A Gemfile

```ruby
# ~/.dotbox/Gemfile
source "https://rubygems.org"
ruby "2.0.0"

gem "dotbox"
```

Ruby version files for rvm

```
# ~/.dotbox/.ruby-version
ruby-2.0.0

# ~/.dotbox/.ruby-gemset
dotbox
```

Bundle creating the binstub for dotbox

```bash
$ bundle install --binstubs
```

At this point it might be a good idea to set the binstub on your path for easier access. For bash, in your `.bashrc`:

```bash
export PATH=$PATH:$HOME/.dotbox/bin
```

Reload your bash shell

```bash
$ source ~/.bashrc
```

And then push your configs (if you want them)

```bash
$ dotbox push
```

(yup, using dotbox to make dotbox work better)

#### With an existing repo

```bash
$ dotbox init --repo git@github.com:stevenosloan/dotbox.git
```

This will clone the specified repo into `~/.dotbox/source`

#### With no repo

```bash
$ dotbox init
```

This will init a git repo in `~/.dotbox/source` and duplicate all dotfiles in your home directory into it. (Note that if you have any nested resources you'd like to manage you'll need to duplicate them yourself). You can then commit the files you want to track (delete the rest) and setup a remote.

```bash
$ dotbox update
```

Will run the update task, that will symlink all the tracked dotfiles to their destination. In case of conflicts you'll be asked to create a `#{dotfile_name}.bak` file as a backup.

#### Syncing your settings

`dotbox update`  
Pulls remote changes into the local repository, and attempts to update the local dotfiles.

`dotbox push`  
Makes a naive attempt to push the local repository to the remote.

## Testing

```bash
$ rspec
```

## Contributing

If there is any thing you'd like to contribute or fix, please:

- Fork the repo
- Add tests for any new functionality
- Make your changes
- Verify all new &existing tests pass
- Make a pull request


## License
The dotbox gem is distributed under the [MIT License](LICENSE).