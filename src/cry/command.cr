require "cli"
require "colorize"

module Cry
  class Command < ::Cli::Command
    class Options
      arg "code", desc: "Crystal code or .cr file to execute within the application scope", default: ""
      bool ["-l", "--log"], desc: "Prints results of previous runs"
      string ["-e", "--editor"], desc: "Preferred editor: [vim, nano, pico, etc], only used when no code or .cr file is specified", default: ENV["EDITOR"]? || "vim"
      string ["-b", "--back"], desc: "Runs previous command files: 'amber exec -b [times_ago]'", default: "0"
      bool ["-r", "--repeat"], desc: "Runs editor in a loop"
    end

    class Help
      caption "# It runs Crystal code within the application scope"
    end

    def run
      if args.log?
        Cry::Logs.new.print
      else
        Cry::CodeRunner.new(
          code: args.code,
          back: back,
          editor: args.editor,
          repeat: args.repeat?
        ).run
      end
    end

    private def back : Int32
      if args.repeat?
        1
      else
        args.back.to_i(strict: false) || 0
      end
    end
  end
end
