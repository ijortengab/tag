# Tag

Tag is Command Line Interface tools to add or modify `tag` or `label` in filename.

Inspired from [TagSpaces](https://www.tagspaces.org/).

## Setup

Download with curl.

```
curl https://git.io/tag.sh -Lso tag
```

or wget.

```
wget https://git.io/tag.sh -qO tag
```

Save file as `tag` name, then put in your $PATH.

```
chmod +x tag
sudo mv tag -t /usr/local/bin
```

Verify.

```
which tag
```

## Getting started

1. Add `favourite` and `live` tag in `Padi - Harmoni Live Cover by Mitty Zasia-pJTGy0P6hwg.mp4` file.

```
tag add favourite live 'Padi - Harmoni Live Cover by Mitty Zasia-pJTGy0P6hwg.mp4'
# File renamed to `Padi - Harmoni Live Cover by Mitty Zasia-pJTGy0P6hwg[favourite live].mp4`
```

2. Add `trip-Bali-2021` tag to all JPEG files in Your Photos directory.

```
ls ~/Photos/*.jpg | tag add trip-Bali-2021
```

3. If `ls` command have `path` argument and return relative `path` filename,
add `--directory` or `-D` options to make it same `path` as `ls` command.

```
ls ~/Photos/event/ | tag add hiking -D ~/Photos/event/
```

4. Use wildcard (`*`) in `ls` command, if you haven't finished tagging the files.

```
ls IMG-20201201-171501* | tag add hiking
# Press UP ARROW in keyboard
ls IMG-20201201-171501* | tag add hiking gede-mountain
# Press UP ARROW in keyboard
ls IMG-20201201-171501* | tag add hiking gede-mountain trip-2015
# File renamed
# from `IMG-20201201-171501.jpg`
# to   `IMG-20201201-171501[gede-mountain hiking trip-2015].jpg`
```

5. Bulk rename tag in filename.

```
tag find hiking -w -f | tag delete hiking | tag add adventure
# File renamed
# from `IMG-20201201-171501[gede-mountain hiking trip-2015].jpg`
# to   `IMG-20201201-171501[adventure gede-mountain trip-2015].jpg`
```

## Documentation

From `tag --help`.

```
Usage: tag <command> [arguments|STDIN]

Available Commands
   add        Add tag(s) to the file (Alias: a)
   delete     Delete tag(s) from the file (Alias: d)
   clear      Clear all the tag(s) from the file (Alias: c)
   find       Find tag by text or word (Alias: f)

Format Command
   tag add|a    [-nfd]   [-D <n>] <file|STDIN> <tag> [<tag>]...
   tag delete|d [-nfd]   [-D <n>] <file|STDIN> <tag> [<tag>]...
   tag clear|c  [-nfd]   [-D <n>] <file|STDIN> [<file>]...
   tag find|f   [-1aiwp] [-x <n>]... <tag> [<tag>]...

Global options
   -h, --help
        Print this help
   -f, --type f
        Only processes regular files, even though there is directory in
        arguments
   -d, --type d
        Only processes directories, even though there is regular file in
        arguments

Options for Add, Delete, and Clear command
   -n, --dry-run
        Perform a trial run with no changes made
   -D, --directory
        Set the directory if file argument is not relative to $PWD.
   -t, --tag-file=<n>
        Set filename for Tagging Directory. The extension `.tag` must not
        contains in argument, because it always added.

Options for Find command
   -1   Find in starting point directory level depth only and no recursive.
        This is equals to `maxdepth 1` in find command.
   -a, --all
        Do not exclude directory starting with .
   -i, --ignore-case
        Ignore case distinctions.
   -w, --word
        Find tag by word. Default is find tag by containing text
   -p, --preview
        Preview find command without execute it
   -x, --exclude-dir=<dir>
        Skip directory and all files inside them. Repeat option to skip other
        directory

Tagging directory.
   - Tag the directory doesn't rename the directory name.
   - Tag the directory will create a `.tag` file inside the directory and put
     the tags inside that file. The extension `.tag` cannot be changed but you
     can add filename with `--tag-file` option.

Example
   tag add "November Rain.mp3" love rock
   tag add . work todo
   ls *.jpg | tag add trip 2021
```
