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
        issue = Command.ui.ask("Issue number (omit to create new issue):")

        message = "Plunger: TEST Plunger"

        reviewers = []

        if reviewers.empty?
          Command.ui.say("No reviewers detected")
        else
          Command.ui.say("Found reviewers:")
          reviewers.each { |reviewer| Command.ui.say(reviewer) }
        end

        reviewers +=
          Command.ui.ask("Specify another reviewers (comma separated email addresses):").
          split(',').
          map { |reviewer| reviewer.strip }

        Uploader.new.run({
          'server'    => Config.data['server'],
          'email'     => Config.data['email'],
          'issue'     => issue,
          'send_mail' => true,
          'message'   => message,
          'reviewers' => reviewers.uniq.join(',')
        }, [
          'v0.0.1..HEAD'
        ])
      end
    end
  end
end
