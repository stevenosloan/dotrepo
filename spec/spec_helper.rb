require 'rspec'
require 'catch_and_release'
require 'support/given'

require 'pry'

RSpec.configure do |c|
  c.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles        = true
  end
end

# for eating up stdout & stderr
unless ENV['VERBOSE']
  stdout  = StringIO.open('','w+')
  $stdout = stdout

  stderr  = StringIO.open('','w+')
  $stderr = stderr
end

require 'dotbox'