# Tag

Tag is Command Line Interface tools to add or modify `tag` ( or `label`) in filename and directory.

Inspired from [TagSpaces](https://www.tagspaces.org/).

## Setup

Download with curl.

```
curl -L https://git.io/tag.sh -o tag
```

or wget.

```
wget https://git.io/tag.sh -O tag
```

Save file as `tag` name, then put in your $PATH variable.

```
chmod +x tag
sudo mv tag -t /usr/local/bin
# or
[ -d ~/bin ] && mv tag -t ~/bin
```

Verify.

```
which tag
```

## Getting started

1. Add `love` and `rock` tag in `November Rain.mp3` file.

```
tag add -f 'November Rain.mp3' -t love -t rock
```

File renamed to `November Rain[love rock].mp3`

If you are sure that the file 'November Rain.mp3' exists and there are not file
named `rock` and `love` in current directory, you can use this free-style
command:

```
tag add love rock 'November Rain.mp3'
```

2. Add `trip-Bali-2021` tag to all JPEG files in Your Photos directory.

```
ls ~/Photos/*.jpg | tag add trip-Bali-2021
```

3. If `ls` command have `path` argument and return relative `path` filename,
add `--directory` or `-d` options to make it same `path` as `ls` command.

```
ls ~/Photos/event/ | tag add hiking -d ~/Photos/event/
```

4. Use wildcard (`*`) in `ls` command, if you haven't finished tagging the files.

```
ls IMG-20201201-171501* | tag add hiking
# Press UP ARROW in keyboard
ls IMG-20201201-171501* | tag add hiking gede-mountain
# Press UP ARROW in keyboard
ls IMG-20201201-171501* | tag add hiking gede-mountain trip-2015
```

File renamed from `IMG-20201201-171501.jpg` to `IMG-20201201-171501[gede-mountain hiking trip-2015].jpg`

5. Bulk rename tag in filename.

```
tag find hiking -w -F | tag delete hiking | tag add adventure
```

File renamed from `IMG-20201201-171501[gede-mountain hiking trip-2015].jpg` to `IMG-20201201-171501[adventure gede-mountain trip-2015].jpg`

## Documentation

From `tag --help`.

```
Usage: tag <command> [arguments|STDIN]

Available Commands
   add        Add tag(s) to the file (Alias: a)
   set        Set tag(s) to the file, existing tags will be replaced (Alias: s)
   delete     Delete tag(s) from the file (Alias: d)
   empty      Empty all tag(s) from the file (Alias: e)
   find       Find tag by text or word (Alias: f)
   export     Export all tag from the file (Alias: x)
   copy       Copy tag from source file to target files (Alias: c)

Format Command
   tag add|a     [-n]     [-d <d>] [-T <f>] [-f <n|STDIN>]... [-t <n>]...
   tag set|s     [-n]     [-d <d>] [-T <f>] [-f <n|STDIN>]... [-t <n>]...
   tag delete|d  [-n]     [-d <d>] [-T <f>] [-f <n|STDIN>]... [-t <n>]...
   tag empty|e   [-n]     [-d <d>] [-T <f>] [-f <n|STDIN>]...
   tag find|f    [-raiwp] [-x <d>]...                         [-t <n>]...
   tag export|x           [-d <d>]          [-f <n|STDIN>]...
   tag copy|c    [-n]     [-d <d>] [-T <f>] [-f <n|STDIN>]... [-t <n>]...
                 <SOURCE>

Free-style format
   tag <command> <options> <operand> [<operand>]...

   Operands that are file names considered as files (will be set as argument
   of -f option), otherwise as tags (will be set as argument of -t option).

   Special for copy command, the first operand must be source file.

Global options
   -h, --help
        Print this help
   -v, --version
        Print current version
   -F, --type f
        Only processes regular files and skip all directory
   -D, --type d
        Only processes directories and skip all regular file

Options
   -f, --file n
        Set the filename or dirname to be processed
        Not affected for `find` command.
   -t, --tag n
        Set the name tag to be processed
        Not affected for `empty` and `export` command.
   -d, --directory
        Set the directory if file argument is not relative to $PWD.
        Not affected for `find` command.
   -T, --tag-file=<n>
        Set filename for Tagging Directory only. The extension `.tag` must not
        contains in argument, because it always added.
        Not affected for `find` command.
   -n, --dry-run
        Perform a trial run with no changes made.
        Not affected for `find` and `export` command.

Options for `find` command
   -r, --recursive
        Find in current directory and each directory recursively. Default is
        find in current directory only.
   -a, --all
        Do not exclude directory starting with .
   -i, --ignore-case
        Ignore case distinctions
   -w, --word
        Find tag by word. Default is find tag by containing text.
        Attention. For example: `-w fair`, then:
         - match for `fair` tag
         - match for `fair-play` tag
         - not match for `fairness` tag
   -p, --preview
        Preview find command without execute it
   -x, --exclude-dir=<dir>
        Skip directory and all files inside them. Repeat option to skip other
        directory.

Example
   tag add "November Rain.mp3" love rock
   ls ~/Photos/*.jpg | tag add trip-Bali-2021
   ls ~/Photos/event/ | tag add hiking -D ~/Photos/event/
   ls IMG-20201201-171501* | tag add hiking
   ls IMG-20201201-171501* | tag add hiking gede-mountain
   ls IMG-20201201-171501* | tag add hiking gede-mountain trip-2015
   tag find hiking -w -F | tag delete hiking | tag add adventure

Tagging directory
   - Tag the directory doesn't rename the directory name.
   - Tag the directory will create a `.tag` file inside the directory and put
     the tags inside that file.
   - Extension `.tag` cannot be changed but you can add filename with
    `--tag-file` option or include that file in path.

Example
   tag add . work todo
   tag add ~/Photos --tag-file=.metadata   event trip
   tag add ~/Photos/.metadata.tag          event trip
```
