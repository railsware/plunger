require 'rubygems/user_interaction'

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
          !File.exists?(config_path)
        end

        def config_path
          @config_path ||= File.join(Gem.user_home, '.gem', 'plunger')
        end
      end

      def run
        ui.say "Please configure plunger"
        [
          ['server', 'Code review server', 'coderev.railsware.com'],
          ['python_bin', 'Path to python v2 binary', 'python']
        ].each do |args|
          configure_option(*args)
        end

        save_configuration
        ui.say "Configuration saved to #{config_path}"
      end

      protected

      def ui
        @ui ||= Gem::ConsoleUI.new
      end

      def config_path
        self.class.config_path
      end

      def configuration
        @configuration ||= Gem.configuration.load_file(config_path)
      end

      def configure_option(name, description, default)
        configuration[name] ||= default
        value = configuration[name]
        value = ui.ask("#{description} (#{value}):")
        configuration[name] ||= default 
        configuration[name] = value unless value.empty?
      end

      def save_configuration
        dirname = File.dirname(config_path)

        Dir.mkdir(dirname) unless File.exists?(dirname)

        File.open(config_path, 'w') do |f|
          f.write configuration.to_yaml
        end
      end

    end
  end
end
