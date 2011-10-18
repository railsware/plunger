module Plunger
  module Command
    class << self
      def names
        %w(push upgrade configure)
      end

      def autorun
        names.each do |name|
          run(name) if command_class(name).autorun?
        end
      end

      def run(name)
        command_class(name).new.run
      end

      def command_class(name)
        Plunger::Command.const_get(Utils.camelize(name))
      end
    end
  end
end

Plunger::Command.names.each do |name|
  require "plunger/command/#{name}"
end
