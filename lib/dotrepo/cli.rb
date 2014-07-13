require 'thor'
require 'dotrepo'

module Dotrepo
  class CLI < Thor

    desc "version", "display version"
    def version
      say "Dotrepo::VERSION #{Dotrepo::VERSION}"
    end

    desc "info", "display current configuration"
    def info
      config = Dotrepo::ConfigFile.new
      [:source, :destination].each do |attr|
        shell.say_status "#{attr}:", config.send(attr), :bold
      end
    end

    desc "setup", "setup your dotfile repo"
    method_option :repo,
                  aliases: "-r",
                  desc: "repo to pull dotfiles from"
    def setup
      unless options[:repo]
        shell.say_status "error", "you must specify a repo", :red
        return
      end

      system "git clone #{options[:repo]} #{config.source}"
      DotFileManager.new( config.source, config.destination ).symlink_dotfiles
    end

    desc "refresh", "link new dotfiles"
    def refresh
      # runs the manager again to symlink new files & prune abandoned files
      DotFileManager.new( config.source, config.destination ).symlink_dotfiles
    end

    desc "repo", "cd to the repo directory"
    def repo
      puts File.expand_path(config.source)
    end

    desc "uninstall", "revert symlinked files to plain dotfiles"
    def uninstall
    end

    private

      def config
        @_config ||= Dotrepo::ConfigFile.new
      end

  end
end