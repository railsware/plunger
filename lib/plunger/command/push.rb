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

        message     = changeset.title
        description = changeset.description
        reviewers   = changeset.author_emails

        if reviewers.empty?
          Command.ui.say("No reviewers detected")
        else
          Command.ui.say("Found reviewers in the changeset:")
          reviewers.each { |reviewer| Command.ui.say(reviewer) }
        end

        issue = Command.ui.ask("Issue number (omit to create new issue):")

        reviewers +=
          Command.ui.ask("Specify another reviewers (comma separated email addresses):").
          split(',').
          map { |reviewer| reviewer.strip }

        Uploader.new.run({
          'server'      => Config.data['server'],
          'email'       => Config.data['email'],
          'issue'       => issue,
          'send_mail'   => true,
          'message'     => message,
          'description' => description,
          'reviewers'   => reviewers.uniq.join(',')
        }, [
          changeset.range
        ])
      end
    end
  end
end
