require 'rubygems/user_interaction'

module Plunger
  module Command
    class << self
      def names
        %w(push upgrade configure)
      end

      def classes
        @classes ||= self.names.map { |name| command_class(name) }
      end

      def autorun
        names.each do |name|
          run(name, {}) if command_class(name).autorun?
        end
      end

      def run(name, options)
        command_class(name).new.run(options)
      end

      def command_class(name)
        Plunger::Command.const_get(Utils.camelize(name))
      end

      def ui
        @ui ||= Gem::ConsoleUI.new
      end

      def spawn_result(command)
        result = `#{command}`
        $?.success? or abort
        result
      end
    end
  end
end

Plunger::Command.names.each do |name|
  require "plunger/command/#{name}"
end
