require 'rspec'
require 'catch_and_release'
require 'support/given'

require 'pry'

# for eating up stdout & stderr
unless ENV['VERBOSE']
  stdout  = StringIO.open('','w+')
  $stdout = stdout

  stderr  = StringIO.open('','w+')
  $stderr = stderr
end

require 'dotbox'