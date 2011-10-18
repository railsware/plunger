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
          false
        end
      end

      def run
        p "UPGRADE"
      end
    end
  end
end
