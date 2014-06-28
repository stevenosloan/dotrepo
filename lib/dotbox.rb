require 'yaml'

require_relative 'dotbox/dot_file'
require_relative 'dotbox/dot_file_manager'
require_relative 'dotbox/config_file'

unless Dotbox.const_get(:VERSION)
  require_relative 'dotbox/version'
end
