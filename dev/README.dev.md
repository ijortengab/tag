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
{{HELP}}
```
