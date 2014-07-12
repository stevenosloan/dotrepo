require 'yaml'

require_relative 'dotrepo/dot_file'
require_relative 'dotrepo/dot_file_manager'
require_relative 'dotrepo/config_file'

unless Dotrepo.const_get(:VERSION)
  require_relative 'dotrepo/version'
end
