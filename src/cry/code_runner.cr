module Cry
  class CodeRunner
    private getter filename_seed : Int64 = Time.now.epoch_ms
    private getter code : String
    private getter editor : String
    private getter back : Int32
    private getter? repeat : Bool

    def initialize(@code, @editor, @back = 0, @repeat = false)
    end

    def run
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
