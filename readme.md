**dotrepo**, because the world ~~didn't~~ need another dotfile manager.

Just a project done for fun, not due to a particular dislike of other implementations or idea that this would be any better.

## Scenario

You work on multiple machines and want to make sure that your dotfiles are easily synced between them.


## Use

First you need to have ruby 1.9.3+ installed, preferably with rvm as your system default.


### Installation

#### Install as Global Gem

`$ gem install dotrepo`


#### Install to Dotrepo dir w/ rvm

This is the suggested method as you don't have to worry about switching gemsets and loosing access to dotrepo -- some care needs to be takent to stick w/in compatible rubies though (1.9.3+).

**First setup the repo**

`$ mkdir -p ~/.dotrepo`

**Add a Gemfile**
`$ touch ~/.dotrepo/Gemfile`

Then make sure the contents specify a compatible ruby version & the dotrepo gem

```ruby
source 'https://rubygems.org'
ruby '2.0.0'

gem 'dotrepo'
```

And bundle install generating a binstub.

`$ bundle binstubs dotrepo`

No we'll make a tweak to the binstub to ensure it's using the correct ruby version.

The first line of `bin/dotrepo` should look like:
```
#!/usr/bin/env ruby
```

We'll change that to
```
#!/usr/bin/env rvm 2.0.0 do ruby
```

So that we're specifying the same ruby version we set in our Gemfile.

**Add dotrepo to your path**
Now in your `.bashrc` or `.bash_profile` (depending on the system you use), add:
```bash
export PATH=$PATH:$HOME/.dotrepo/bin
```


### Setup

#### With an existing repo

```bash
$ dotrepo setup --repo git@github.com:stevenosloan/toolbox.git
```

This will clone the specified repo into `~/.dotrepo/repo`

#### With no repo

```bash
$ dotrepo setup --no-repo --files .bashrc .bash_profile
```

This will init a git repo in `~/.dotrepo/repo` and duplicate all specified dotfiles in your home directory into it. You can then commit the files you want to track (delete the rest) and setup a remote.


### Continued Use

```bash
$ dotrepo refresh
```

If files have been added to the dotrepo repository, this will make an attempt to symlink those as well.

```bash
$ dotrepo repo
# => the repo directory

$ cd `dotrepo repo`
# => cd into the repo directory
```

Quick access to the repo, cd's into that directory to speed managment.


### Uninstall

We're sad to see you go, but we want to make it easy to reverse the setup.

```bash
$ dotrepo uninstall
```

Will remove the symlinks and make a copy of the symlinked files in your `~/` directory.



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
The dotrepo gem is distributed under the [MIT License](LICENSE).