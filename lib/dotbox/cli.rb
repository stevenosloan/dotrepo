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
    def setup
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

  end
end