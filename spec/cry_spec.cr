require "./spec_helper"

describe Cry do
  it "should evaluate command" do
    expected_result = %("Hello World"\n)
    Cry::Command.run([%("Hello World")])
    newest_result.should eq expected_result
  end

  it "executes a .cr file from the first command-line argument" do
    File.write "amber_exec_spec_test.cr", "puts([:a] + [:b])"
    Cry::Command.run(["amber_exec_spec_test.cr", "-e", "tail"])
    newest_result.should eq "[:a, :b]\n"
    File.delete("amber_exec_spec_test.cr")
  end

  it "opens editor and executes .cr file on close" do
    Cry::Command.run(["-e", "echo 'puts 1000' > "])
    newest_result.should eq "1000\n"
  end

  it "copies previous run into new file for editing and runs it returning results" do
    Cry::Command.run(["1337"])
    Cry::Command.run(["-e", "tail", "-b", "1"])
    newest_result.should eq "1337\n"
  end

  it "accepts a template file when passing in code" do
    Cry::CodeRunner.new(
      code: %(puts "Hello World!"),
      editor: "tail",
      template: "spec/support/template.cr",
    ).run

    newest_result.should eq <<-RESULT
    From template
    Hello World!
    nil

    RESULT
    newest_code.should eq <<-CODE
    puts "From template"
    puts (puts "Hello World!").inspect
    CODE
  end

  it "accepts a template file when using just the editor" do
    Cry::CodeRunner.new(
      code: "",
      editor: "tail",
      template: "spec/support/template.cr",
    ).run

    newest_result.should eq "From template\n"
    newest_code.should eq %(puts "From template"\n)
  end

  it "logs to the configured location" do
    change_logs_directory "./tmp/console" do
      original_log_count = `ls tmp/console/*_console_result.log`.strip.split(/\s/).size

      Cry::CodeRunner.new(
        code: %(puts "Hello World!"),
        editor: "echo",
      ).run

      logs = `ls tmp/console/*_console_result.log`.strip.split(/\s/).sort
      logs.size.should eq(original_log_count + 1)
      File.read(logs.last).should contain "Hello World!"
    end
  end
end

private def change_logs_directory(directory)
  original_logs_directory = Cry::Logs.directory
  begin
    Cry::Logs.directory = directory
    yield
  ensure
    Cry::Logs.directory = original_logs_directory
  end
end

private def newest_code
  Cry::Logs.new.newest.code
end

private def newest_result
  Cry::Logs.new.newest.results
end
