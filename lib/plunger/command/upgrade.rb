require 'rubygems/dependency_installer'

module Plunger
  module Command
    class Upgrade
      class << self
        def command
          'upgrade'
        end

        def description
          'Upgrade plunger gem'
        end

        def autorun?
          true
        end
      end

      def run(options)
        Command.ui.say("Checking plunger update ...")

        req = Gem::Requirement.new(">#{Plunger::VERSION}")
        dep = Gem::Dependency.new('plunger', req)
        tuples = Gem::SpecFetcher.fetcher.fetch(dep)

        if tuples.empty?
          Command.ui.say("Plunger is up to date")
        else
          spec, source = tuples.first
          Command.ui.say("Upgrading #{Plunger::VERSION} to #{spec.version}")
          installer = Gem::DependencyInstaller.new
          installer.install(spec.name, spec.version.to_s)
          exit
        end

        true
      end
    end
  end
end
