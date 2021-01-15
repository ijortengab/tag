# Tag

Tag is Command Line Interface tools to add or modify `tag` ( or `label`) in filename and directory.

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
tag add love rock 'November Rain.mp3'
```

File renamed to `November Rain[love rock].mp3`

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
```

File renamed from `IMG-20201201-171501.jpg` to `IMG-20201201-171501[gede-mountain hiking trip-2015].jpg`

5. Bulk rename tag in filename.

```
tag find hiking -w -f | tag delete hiking | tag add adventure
```

File renamed from `IMG-20201201-171501[gede-mountain hiking trip-2015].jpg` to `IMG-20201201-171501[adventure gede-mountain trip-2015].jpg`

## Documentation

From `tag --help`.

```
{{HELP}}
```
