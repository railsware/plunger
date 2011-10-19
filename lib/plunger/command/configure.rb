require 'yaml'

module Plunger
  module Command
    class Configure
      class << self
        def command
          'configure'
        end

        def description
          'Configure plunger'
        end

        def autorun?
          !Config.exists?
        end
      end

      def config_file
        File.expand_path('../../../../config/configure_options.yml', __FILE__)
      end

      def configure_options
        YAML.load_file(config_file)
      end

      def run
        Command.ui.say "Please configure plunger (enter nothing if you don't want to change option)"

        configure_options.each do |option|
          configure(
            option['key'],
            option['description'],
            option['value']
          )
        end

        Plunger::Config.save

        Command.ui.say "Configuration saved to #{Plunger::Config.path}"

        true
      end

      protected

      def configure(name, description, default)
        Plunger::Config.data[name] ||= default
        value = Plunger::Config.data[name]
        value = Command.ui.ask("#{description} (#{value}):")
        Plunger::Config.data[name] = value unless value.empty?
      end
    end
  end
end
