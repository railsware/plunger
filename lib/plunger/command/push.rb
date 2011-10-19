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
        unless changeset_class = Changeset.detect_class
          Command.ui.say("Can't detect SCM")
          return false
        end

        revisions = [
          [changeset_class.initial_revision, "initial" ],
          [changeset_class.final_revision,   "final"   ]
        ].map do |default, description|
          revision = Command.ui.ask("Specify #{description} revision or reference (#{default}):")
          revision.empty? ? default : revision
        end

        changeset = changeset_class.new(*revisions)

        changeset.empty? and abort("Changeset #{changeset.range} is empty")

        message     = changeset.message
        description = changeset.description
        reviewers   = filter_reviewers(changeset.author_emails)

        if reviewers.empty?
          Command.ui.say("No reviewers detected")
        else
          Command.ui.say("Found reviewers in the changeset:")
          reviewers.each { |reviewer| Command.ui.say(reviewer) }
        end

        reviewers += normalize_reviewers(
          Command.ui.ask("Specify another reviewers (comma separated email addresses or just names):")
        )

        issue = Command.ui.ask("Issue number (omit to create new issue):")

        Uploader.new.run({
          'server'      => Config.data['server'],
          'email'       => Config.data['email'],
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
