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

1. Add `favourite` tag in `Padi - Harmony (Cover by Mitty Zasia).mp3` file.

```
tag add favourite 'Padi - Harmony (Cover by Mitty Zasia).mp3'
# File renamed to `Padi - Harmony (Cover by Mitty Zasia)[favourite].mp3`
```

2. Add `trip-Bali-2021` tag to all JPEG files in Your Photos directory.

```
ls ~/Photos/*.jpg | tag add trip-Bali-2021
```

3. If `ls` command have `path` argument and return relative `path` filename,
add --directory options to make it same `path` as `ls` command.

```
ls ~/Photos/event/ | tag add hiking -d ~/Photos/event/
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
   tag add|a [-n] [-d <n>] <file|STDIN> <tag> [<tag>]...
   tag delete|d [-n] [-d <n>] <file|STDIN> <tag> [<tag>]...
   tag clear|c [-n] [-d <n>] <file|STDIN> [<file>]...
   tag find|f [-1aiwp] [-x <n>] <tag> [<tag>]...

Options for Add, Delete, and Clear command
   -n, --dry-run
        Perform a trial run with no changes made
   -d, --directory
        Set the directory if file argument is not relative to $PWD.

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

Example
   tag add love rock "November Rain.mp3"
   ls *.jpg | tag add trip 2021

Tagging directory.
   - Tag the directory doesn't rename the directory name.
   - Tag the directory will create a `.tag` file inside the directory and put
     the tags inside that file.
```
