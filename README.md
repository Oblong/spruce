Oblong C++ formatter
====================

Spruce is Oblong's .clang-format file, wrapped in a crunchy outer shell.

## Install

### Mac

#### Homebrew
```bash
# Install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Get access to Oblong's tap
brew tap Oblong/tools

# Install
brew install spruce

# Upgrading
brew update
brew upgrade spruce
```

### Ubuntu
```bash
# Once you have access to oblong's repository, install the oblong-spruce package, e.g.
sudo apt-get install oblong-spruce
```

## Examples

spruce --help

## Known Issues

There are some bugs we have had to work around or accept with the clang-format
tool. Below lists these out:

- **AlwaysBreakBeforeMultilineStrings**: This value must be false or else line
  breaks are introduced in all strings containing our OB_FMT_64, etc.
- **BraceWrapping/AfterEnum**: This setting is broken. See https://bugs.llvm.org/show_bug.cgi?id=27381
