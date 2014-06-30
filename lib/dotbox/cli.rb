require 'thor'
require 'dotbox'

module Dotbox
  class CLI < Thor

    desc "version", "display version"
    def version
      say "Dotbox::VERSION #{Dotbox::VERSION}"
    end

    desc "info", "display current configuration"
    def info
      config = Dotbox::ConfigFile.new
      [:source, :destination].each do |attr|
        shell.say_status "#{attr}:", config.send(attr), :bold
      end
    end

    desc "setup", "setup your dotbox"
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
      # runs the manager to symlink files
    end

    desc "doctor", "analyze your setup for common issues"
    def doctor
      # do some smart checking based on info
      # - does the source exist as a git repo
      # - is the source up to date & free of modified files
      # - does the source have any dotfiles
      # - does the destination exist
    end

    private

      def config
        @_config ||= Dotbox::ConfigFile.new
      end

  end
end