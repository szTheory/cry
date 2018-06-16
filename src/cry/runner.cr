require "cli"
require "colorize"

module Cry
  class Runner
    private getter filename_seed : Int64 = Time.now.epoch_ms
    private getter code : String
    private getter? log : Bool
    private getter editor : String
    private getter back : Int32
    private getter? repeat : Bool

    def initialize(@code, @editor, @log = false, @back = 0, @repeat = false)
    end

    def run
      if log?
        logs = Dir.glob("./tmp/*_console_result.log")
        str = String.build do |s|
          logs.sort.reverse.each_with_index do |f, i|
            s.puts "cry --back #{i + 1}".colorize(:yellow).mode(:underline)
            s.puts "\n# Code:".colorize.colorize(:dark_gray)
            s.puts File.read(f.gsub("_result.log", ".cr")).colorize(:light_gray)
            s.puts "\n# Results:".colorize(:dark_gray)
            s.puts File.read(f).colorize(:light_gray)
            s.puts "\n"
          end
        end
        system("echo '#{str}' | less -r")
      else
        Dir.mkdir("tmp") unless Dir.exists?("tmp")

        loop do
          unless code.blank? || File.exists?(code)
            File.write(filename, "puts (#{code}).inspect")
          else
            prepare_file
            system("#{editor} #{filename}")
          end

          break unless File.exists?(filename)

          result = ""
          result = `crystal eval 'require "#{filename}";'`

          File.write(result_filename, result) unless result.nil?
          puts result

          break unless repeat?
          puts "\nENTER to edit, q to quit"
          input = gets
          break if input =~ /^q/i
        end
      end
    end

    def prepare_file
      _filename = if File.exists?(code)
                    code
                  elsif back > 0
                    Dir.glob("./tmp/*_console.cr").sort.reverse[back - 1]?
                  end

      system("cp #{_filename} #{filename}") if _filename && File.exists?(_filename)
    end

    def filename
      "./tmp/#{filename_seed}_console.cr"
    end

    def result_filename
      "./tmp/#{filename_seed}_console_result.log"
    end
  end
end
