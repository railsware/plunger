module Plunger
  module Command
    class Push
      class << self
        def command
          'push'
        end

        def description
          'Push code diff for review'
        end

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
