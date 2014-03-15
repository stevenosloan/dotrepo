module Dotbox
  class DotFile
    attr_reader :path, :source, :destination

    def initialize path, manager
      @path        = path
      @source      = File.join manager.source, path
      @destination = File.join manager.destination, path
    end

    def source_exists?
      File.exist? source
    end

    def destination_exists?
      File.exist? destination
    end

    def backup_destination
      File.rename( destination, "#{destination}.bak" )
    end

    def linked?
      destination_exists? &&
        File.symlink?(destination) &&
        File.readlink(destination) == source
    end

    def symlink_to_destination
      return if linked?

      if destination_exists?
        print "#{destination} exists. backup existing file and link? (y|n) "
        input = $stdin.gets.chomp
        return unless input.downcase == "y"

        backup_destination
      end
      symlink_to_destination!
    end

    def symlink_to_destination!
      File.symlink destination, source
    end

  end
end
