require 'plunger/changeset/git'

module Plunger
  module Changeset

    class << self
      def classes
        [Git]
      end

      def detect_class
        self.classes.find { |klass| klass.detected? }
      end
    end

  end
end
