module Plunger
  class Config
    class << self
      def exists?
        File.exists?(path)
      end

      def path
        @path ||= File.join(Gem.user_home, '.gem', 'plunger')
      end

      def load
        Gem.configuration.load_file(path)
      end

      def save
        dirname = File.dirname(path)

        Dir.mkdir(dirname) unless File.exists?(dirname)

        File.open(path, 'w') do |f|
          f.write data.to_yaml
        end
      end

      def data
        @data ||= self.load
      end

      def email
        data['username'] << '@' << data['domain']
      end
    end
  end
end

