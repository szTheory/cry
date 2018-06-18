require "colorize"

module Cry
  class Logs
    def print
      str = String.build do |s|
        logs.each_with_index do |log, i|
          s.puts "cry --back #{i + 1}".colorize(:yellow).mode(:underline)
          s.puts "\n# Code:".colorize.colorize(:dark_gray)
          s.puts log.code.colorize.light_gray
          s.puts "\n# Results:".colorize(:dark_gray)
          s.puts log.results.colorize.light_gray
          s.puts "\n"
        end
      end
      system("echo '#{str}' | less -r")
    end

    def newest : Log
      logs.first
    end

    private def logs : Array(Log)
      Dir.glob("./tmp/*_console_result.log").sort.reverse.map do |path|
        Log.new(path)
      end
    end
  end
end
