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

      def run(options)
        unless changeset_class = Changeset.detect_class
          Command.ui.say("Can't detect SCM")
          return false
        end

        Command.ui.say("Synchronizing repository...")
        changeset_class.sync_repository

        revisions = [
          [changeset_class.initial_revision, :initial ],
          [changeset_class.final_revision,   :final   ]
        ].map do |default, type|
          revision = options[type] || Command.ui.ask("Specify #{type} revision or reference (#{default}):")
          revision.empty? ? default : revision
        end

        changeset = changeset_class.new(*revisions)

        changeset.empty? and abort("Changeset #{changeset.range} is empty")

        unless changeset.initial_commits_count.zero?
          message = "Revision '#{changeset.initial}' contains #{changeset.initial_commits_count} commits that are NOT into '#{changeset.final}' revision! Continue (y/n)"
          Command.ui.ask(message) == 'y' or abort
        end

        reviewers = normalize_reviewers(Config.data['master_reviewer'])

        message     = changeset.message
        description = changeset.description
        reviewers   += filter_reviewers(changeset.author_emails)

        Command.ui.say("Next reviewers will be notified:")
        reviewers.each { |reviewer| Command.ui.say(reviewer) }

        reviewers += normalize_reviewers(
          Command.ui.ask("Specify another reviewers (comma separated email addresses or just names):")
        )

        issue = options[:issue] || Command.ui.ask("Issue number (omit to create new issue):")

        confirmation = "Push changeset '#{message}' "
        if issue.empty?
          confirmation << "to NEW issue"
        else
          confirmation << "to issue##{issue}"
        end
        confirmation << " for code review? (y/n)"
        Command.ui.ask(confirmation) == 'y' || abort

        Uploader.new.run({
          'server'      => Config.data['server'],
          'email'       => Config.email,
          'issue'       => issue,
          'send_mail'   => true,
          'message'     => message,
          'description' => description,
          'reviewers'   => reviewers_to_list(reviewers)
        }, [
          changeset.range
        ])
      end

      protected

      # select only email with google app domain
      def filter_reviewers(reviewers)
        reviewers.map { |reviewer|
          name, domain = reviewer.split('@', 2)
          [name, domain].join('@') if domain == Config.data['domain']
        }.compact.uniq
      end

      # append google app domain if reviewer is not email (name)
      def normalize_reviewers(list)
        list.split(',').map { |reviewer|
          name, domain = reviewer.strip.split('@', 2)
          domain ||= Config.data['domain']
          [name, domain].join('@')
        }.compact.uniq
      end

      def reviewers_to_list(reviewers)
        reviewers.uniq.join(',')
      end
    end
  end
end
