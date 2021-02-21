#!/bin/bash

clear
# Command.
if [[ $(command -v tag) ]];then
    echo Command tag ditemukan
    echo
else
    echo Command tag tidak ditemukan.
    exit
fi
# Directory.
mkdir -p temporary
cd temporary

echo 'Simple tagging one file with two tags.'
touch 'a.jpg'
tester "tag add a.jpg apple banana" -o "a[apple banana].jpg" -fe "a[apple banana].jpg"

echo 'Simple tagging one file with four tags.'
touch 'b.jpg'
tester "tag add 'b.jpg' apple banana manggo cherry" -o "b[apple banana cherry manggo].jpg" -fe "b[apple banana cherry manggo].jpg"

echo 'Tagging all file gif in current level directory with a tag.'
touch 'a.gif'
touch 'b.gif'
touch 'c.gif'
touch 'd.gif'
output=$(cat <<-'EOF'
a[manggo].gif
b[manggo].gif
c[manggo].gif
d[manggo].gif
EOF
)
tester "ls *.gif | tag add manggo" -o "$output" -fe a[manggo].gif -fe b[manggo].gif -fe c[manggo].gif -fe d[manggo].gif

echo 'Tagging all .bin files inside bin directory with a tag.'
mkdir -p bin
touch 'bin/a.bin'
touch 'bin/b.bin'
touch 'bin/c.bin'
touch 'bin/d.bin'
output=$(cat <<-EOF
${PWD}/bin/a[orange].bin
${PWD}/bin/b[orange].bin
${PWD}/bin/c[orange].bin
${PWD}/bin/d[orange].bin
EOF
)
tester "ls bin/*.bin | tag add orange" -o "$output" -fe bin/a[orange].bin -fe bin/b[orange].bin -fe bin/c[orange].bin -fe bin/d[orange].bin

echo 'Tagging all files inside exe directory with a tag and make sure the -d options is require.'
mkdir -p exe
touch 'exe/a.exe'
touch 'exe/b.exe'
touch 'exe/c.exe'
touch 'exe/d.exe'
output=$(cat <<-'EOF'
exe/a[apple].exe
exe/b[apple].exe
exe/c[apple].exe
exe/d[apple].exe
EOF
)
tester "ls exe/ | tag add apple -d exe/" -o "$output" -fe exe/a[apple].exe -fe exe/b[apple].exe -fe exe/c[apple].exe -fe exe/d[apple].exe

echo 'Simple tagging the music directory with two tags.'
mkdir -p music
tester "tag add music pop rock" -o "$PWD/music/.tag" -fe "$PWD/music/.tag"

echo 'Make sure the dot tag file format is correct.'
output=$(cat <<-EOF
# Tags:
 - pop
 - rock
EOF
)
tester "cat $PWD/music/.tag" -o "$output"

echo 'Find the love tag.'
mkdir -p 'music/GnR/'
touch    'music/GnR/November Rain[love rock].mp3'
mkdir -p 'music/Queen/'
cat > 'music/Queen/metadata.tag' <<- 'EOM'
Tags:
 - love
 - slow
EOM
output=$(cat <<-EOF
./music/Queen/metadata.tag
./music/GnR/November Rain[love rock].mp3
EOF
)
tester "tag find -r love" -o "$output"

echo 'List tag in regular file.'
output=$(cat <<-EOF
love
rock
EOF
)
tester "tag export './music/GnR/November Rain[love rock].mp3'" -o "$output"

echo 'List tag inside the metadata.tag file.'
output=$(cat <<-EOF
love
slow
EOF
)
tester "tag export ./music/Queen/metadata.tag" -o "$output"

echo 'Copy tag.'
touch 'a[aa bb cc].png'
touch 'b.png'
tester "tag copy 'a[aa bb cc].png' b.png" -o "b[aa bb cc].png" -fe "b[aa bb cc].png" -fne "b.png"

echo 'Copy tag.'
touch 'c.png'
touch 'd.png'
tester "tag copy c.png d.png" -o "" -fe "c.png" -fe "d.png" --error

echo 'Copy tag.'
touch 'e[ee mm].png'
touch 'f.png'
tester "tag copy 'e[ee mm].png' 'f.png'" -o "f[ee mm].png" -fe "f[ee mm].png" -fne "f.png"

echo 'Copy tag.'
touch 'g[ee mm].png'
touch 'h[bb kk].png'
tester "tag copy 'g[ee mm].png' 'h[bb kk].png'" -o "h[bb ee kk mm].png" -fe "h[bb ee kk mm].png" -fne "h[bb kk].png"

echo 'Copy tag.'
touch 'i[ee kk mm].png'
touch 'j[bb kk].png'
tester "tag copy 'i[ee kk mm].png' 'j[bb kk].png'" -o "j[bb ee kk mm].png" -fe "j[bb ee kk mm].png" -fne "j[bb kk].png"

echo 'Copy tag.'
touch 'k[ee mm kk].png'
touch 'l[kk bb].png'
tester "tag copy -t ww 'k[ee mm kk].png' 'l[kk bb].png'" -o "l[bb ee kk mm ww].png" -fe "l[bb ee kk mm ww].png" -fne "l[kk bb].png"

echo 'Copy tag.'
touch 'm[ee mm kk].png'
touch n.png
touch 'o[kk bb].png'
touch p.png
output=$(cat <<-'EOF'
n[ee kk mm www xxx].png
o[bb ee kk mm www xxx].png
p[ee kk mm www xxx].png
EOF
)
tester "tag copy -t www -t xxx -f n.png 'm[ee mm kk].png' 'o[kk bb].png' p.png" \
-o "$output" -fne "n.png" -fne "o[kk bb].png" -fne "p.png" \
-fe "n[ee kk mm www xxx].png" -fe "o[bb ee kk mm www xxx].png" -fe "p[ee kk mm www xxx].png"

read -rsn1 -p "Delete directory temporary? [y/n]" option

if [[ $option == y ]];then
    cd ..
    rm -rf temporary/
    echo " "Deleted.
else
    echo
    echo
    cd ..
    find temporary/
    echo
    echo rm -rf temporary/
    echo
fi
