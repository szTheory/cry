# CRy

Evaluated crystal code from files and command lines similar to edit in ruby pry.

## Installation from source

    curl -L https://github.com/szTheory/cry/archive/master.tar.gz | tar xz
    cd cry-master/
    make install

## Usage

1. *inline mode*: inline code specified in the command line as a string argument  
   - `cry Time.now`
1. *editor mode*: a terminal-based code editor is opened and the resulting code is executed once you save and exit
   - `cry`... edit code in Vim... code runs.
1. *file mode*: code within an existing .cr file is copied to a tmp file for editing and run once editor is closed.
   - `cry scripts/stuff.cr`
1. *back*: open and previous run in editor mode.
   - `cry -b 1` ... copies previous run to tmp file for editing and runs when editor is closed.
1. *loop*: continuously edit and execute code.
   - `cry -o -b 1` ... copies previous run to tmp file for editing and runs when editor is closed in a loop.
1. *log*: show a log of all previous runs.
   - `cry --log`

Here is a list of the commands available:

```sh
command [OPTIONS] [CODE]

Arguments:
  CODE  Crystal code or .cr file to execute within the application scope
        (default: )

Options:
  -b, --back    Runs prevous command files: 'amber exec -b [times_ago]'
                (default: 0)
  -e, --editor  Prefered editor: [vim, nano, pico, etc], only used when no code or .cr file is specified
                (default: vim)
  -l, --log     Prints results of previous run
  -o, --loop    Runs editor in a loop (can be combined with e.g. -b 1)
```

## Contributing

1. Fork it ( https://github.com/luckyframework/cry/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [elorest](https://github.com/elorest) Isaac Sloan - creator
- [paulcsmith](https://github.com/paulcsmith) Paul Smith - maintainer of this fork.
- [szTheory](https://github.com/szTheory) - fix Makefile