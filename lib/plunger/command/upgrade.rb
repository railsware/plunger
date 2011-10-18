module Plunger
  module Command
    class Upgrade
      class << self
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
