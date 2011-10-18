module Plunger
  module Command
    class Push
      class << self
        def autorun?
          false
        end
      end

      def run
        p "PUSH"
      end
    end
  end
end
