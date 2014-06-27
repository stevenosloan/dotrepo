module Dotbox
  class ConfigFile
    FILE_PATH = File.join( File.expand_path("~"), ".dotbox/config" )

    attr_reader :data

    def initialize
      if File.exists? FILE_PATH
        @data = defaults.merge YAML.load_file FILE_PATH
      else
        @data = defaults
      end
    end

    def source
      fetch_from_data "source"
    end

    def destination
      fetch_from_data "destination"
    end

    private

      def fetch_from_data key
        data[key]
      end

      def defaults
        {
          "source"      => '~/.dotbox/box',
          "destination" => '~/'
        }
      end

  end
end