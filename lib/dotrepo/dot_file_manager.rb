module Dotrepo
  class DotFileManager
    attr_reader :source, :destination

    def initialize source, destination
      @source      = File.expand_path( source )
      @destination = File.expand_path( destination )
    end

    def dotfiles
      Dir.glob( File.join( source, '**/.*' ) )
         .map { |f| f.sub( /#{source}\/?/, '' ) }
         .reject { |f| f.match /.git/ }
         .map { |path| DotFile.new( path, self ) }
    end

    def symlink_dotfiles
      dotfiles.each do |df|
        df.symlink_to_destination
      end
    end

  end

end