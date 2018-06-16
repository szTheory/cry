require "colorize"

module Cry
  class Logs
    def print
      str = String.build do |s|
        logs.each_with_index do |f, i|
          s.puts "cry --back #{i + 1}".colorize(:yellow).mode(:underline)
          s.puts "\n# Code:".colorize.colorize(:dark_gray)
          s.puts File.read(f.gsub("_result.log", ".cr")).colorize(:light_gray)
          s.puts "\n# Results:".colorize(:dark_gray)
          s.puts File.read(f).colorize(:light_gray)
          s.puts "\n"
        end
      end
      system("echo '#{str}' | less -r")
    end

    private def logs
      Dir.glob("./tmp/*_console_result.log").sort.reverse
    end
  end
end
