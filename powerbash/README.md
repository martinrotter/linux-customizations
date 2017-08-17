# powerbash
Tiny &amp; simple pure Bash prompt (partly) inspired by powerline.

### Terminix (Linux)
![alt text](https://raw.githubusercontent.com/martinrotter/powerbash/master/screenshots/powerbash.png)

### Mintty (Cygwin)
![alt text](https://raw.githubusercontent.com/martinrotter/powerbash/master/screenshots/powerbash-mintty.png)

## What is this stuff?
This is fast and tiny set of Bash scripts providing some nice Bash setup, including powerline-inspired prompt and some other enhancements. The prompt offers some nice visual experience and information, including Git repositories metadata.

You need these things to get powerbash running:

* Bash,
* terminal emulator,
* Perl.

## What it shows?
This is simple prompt which shows:

* current hostname & username,
* working directory,
* result code of previous command,
* current Git branch (if any),
* dirty state of Git branch (if any),
* some specific situations are shown with special color (like error in previous command).

## Installation.
1. Clone this repo into standalone folder: `git clone https://github.com/martinrotter/powerbash.git powerbash`.
2. Source main powerbash script in your `.bashrc`: `source "/path/to/powerbash/powerbash.bash"`.
3. **!optional!** In your `.bashrc`, source script `/path/to/powerbash/utilities.bash`. That will enable some advanced Bash goodies like completion, aliases etc.
4. Make sure that your `.bashrc` does not contain any code which might conflict with powerbash scripts.