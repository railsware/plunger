module Plunger
  module Utils
    extend self

    def camelize(string)
      string.split('_').map{ |s| s.capitalize }.join
    end
  end
end
