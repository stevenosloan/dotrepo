module Dotbox
  class DotFileManager
    attr_reader :source, :destination

    def initialize source, destination
      @source      = source
      @destination = destination
    end

    def dotfiles
      Dir.glob( File.join( source, '**/.*' ) )
         .map { |f| f.sub( /#{source}\/?/, '' ) }
         .map { |path| DotFile.new( path, self ) }
    end

    def symlink_dotfiles
      dotfiles.each do |df|
        df.symlink_to_destination
      end
    end

  end

end