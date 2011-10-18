require 'posix/spawn'

module Plunger
  class Uploader

    def command
      'python2' 
    end

    def script
      File.expand_path('../../../python/upload.py', __FILE__)
    end

    def run(options, diff_options = nil)
      argvs = [ script ]

      options.each do |key, value|
        case value
        when true
          argvs << "--#{key}"
        when false
        else
          argvs << "--#{key}" << "#{value}" unless value.to_s.empty?
        end
      end

      diff_options = Array(diff_options)

      unless diff_options.empty?
        argvs << '--'
        argvs += diff_options
      end

      POSIX::Spawn.system(command, *argvs)
    end

  end
end

=begin

python2 python/upload.py -h

Usage: upload.py [options] [-- diff_options] [path...]

Options:
-h --help               Show this help message and exit.
-y --assume_yes         Assume that the answer to yes/no questions is 'yes'.

Logging options:
  -q --quiet            Print errors only.
  -v --verbose          Print info level logs.
  --noisy               Print all logs.
  --print_diffs         Print full diffs.

Review server options:
  -s --server SERVER    The server to upload to. The format is host[:port].
                        Defaults to 'codereview.appspot.com'.
  -e --email EMAIL      The username to use. Will prompt if omitted.
  -H --host HOST        Overrides the Host header sent with all RPCs.
  --no_cookies          Do not save authentication cookies to local disk.
  --account_type TYPE   Override the default account type (defaults to
                        'GOOGLE', valid choices are 'GOOGLE' and 'HOSTED').

Issue options:
  -d --description DESCRIPTION
                        Optional description when creating an issue.
  -f --description_file DESCRIPTION_FILE
                        Optional path of a file that contains the description
                        when creating an issue.
  -r --reviewers REVIEWERS
                        Add reviewers (comma separated email addresses).
  --cc CC               Add CC (comma separated email addresses).
  --private             Make the issue restricted to reviewers and those CCed

Patch options:
  -m --message MESSAGE  A message to identify the patch. Will prompt if
                        omitted.
  -i --issue ISSUE      Issue number to which to add. Defaults to new issue.
  --base_url BASE_URL   Base URL path for files (listed as "Base URL" when
                        viewing issue).  If omitted, will be guessed
                        automatically for SVN repos and left blank for others.
  --download_base       Base files will be downloaded by the server (side-by-
                        side diffs may not work on files with CRs).
  --rev REV             Base revision/branch/tree to diff against. Use
                        rev1:rev2 range to review already committed changeset.
  --send_mail           Send notification email to reviewers.
  -p --send_patch       Same as --send_mail, but include diff as an
                        attachment, and prepend email subject with 'PATCH:'.
  --vcs VCS             Version control system (optional, usually upload.py
                        already guesses the right VCS).
  --emulate_svn_auto_props
                        Emulate Subversion's auto properties feature.

Use '--help -v' to show additional Perforce options.

=end

