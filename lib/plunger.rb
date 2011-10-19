require "plunger/version"

require 'rubygems'

module Plunger
  autoload :Runner,    'plunger/runner'
  autoload :Changeset, 'plunger/changeset'
  autoload :Command,   'plunger/command'
  autoload :Config,    'plunger/config'
  autoload :Uploader,  'plunger/uploader'
  autoload :Utils,     'plunger/utils'
end
