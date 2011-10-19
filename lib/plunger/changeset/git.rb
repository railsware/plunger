module Plunger
  module Changeset
    class Git
      class << self
        def detected?
          File.exists?('.git')
        end

        def command
          Config.data['git_bin'] || 'git'
        end

        def sync_repository(remote = 'origin')
          system("#{self.command} fetch #{remote}")
        end

        def initial_revision
          'origin/master'
        end

        def final_revision
          revision = Command.spawn_result("#{command} symbolic-ref -q HEAD").strip.split('/').last
          "origin/#{revision}"
        end
      end

      def initialize(initial, final)
        @initial = initial
        @final = final
      end

      attr_reader :initial, :final

      def range
        @range = "#{initial}..#{final}"
      end

      def repository_name
        @repository_name ||= File.split(File.expand_path('.')).last
      end

      def message
        @message ||= "[#{repository_name}] #{range}"
      end

      def description
        @description ||= Command.spawn_result("#{self.class.command} log --pretty='%s' #{range}")
      end

      def empty?
        description.empty?
      end

      def author_emails
        @author_emails ||= Command.spawn_result("#{self.class.command} log --pretty='%ae' #{range}").
          split("\n").
          map { |email| email.strip }.
          uniq
      end

      def commiter_emails
        @commiter_emails ||= Command.spawn_result("#{self.class.command} log --pretty='%ce' #{range}").
          split("\n").
          map { |email| email.strip }.
          uniq
      end

      def initial_commits_count
        @initial_commits_count ||= 
          Command.spawn_result("#{self.class.command} rev-list #{initial} ^#{final}").split("\n").
          size.
          to_i
      end

      def final_commits_count
        @final_commits_count ||= 
          Command.spawn_result("#{self.class.command} rev-list ^#{initial} #{final}").split("\n").
          size.
          to_i
      end
    end
  end
end
