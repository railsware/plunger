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
          !Config.exists?
        end
      end

      def run
        Command.ui.say "Please configure plunger (enter nothing if you don't want to change option)"

        [
          ['server',     'Code review server',       'coderev.railsware.com'     ],
          ['domain',     'Google app domain',        'railsware.com'             ],
          ['email',      'Google app email',         'vasya.pupkin@railsware.com'],
          ['python_bin', 'Path to python v2 binary', 'python'                    ]
        ].each do |args|
          configure(*args)
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
