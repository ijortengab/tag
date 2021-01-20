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
touch 'test-001.jpg'
tester "tag add test-001.jpg apple banana" -o "test-001[apple banana].jpg" -fe "test-001[apple banana].jpg"

echo 'Simple tagging one file with four tags.'
touch 'test-002.jpg'
tester "tag add 'test-002.jpg' apple banana manggo cherry" -o "test-002[apple banana cherry manggo].jpg" -fe "test-002[apple banana cherry manggo].jpg"

echo 'Tagging all file gif in current level directory with a tag.'
touch 'test-001.gif'
touch 'test-002.gif'
touch 'test-003.gif'
touch 'test-004.gif'
output=$(cat <<-'EOF'
test-001[manggo].gif
test-002[manggo].gif
test-003[manggo].gif
test-004[manggo].gif
EOF
)
tester "ls *.gif | tag add manggo" -o "$output" -fe test-001[manggo].gif -fe test-002[manggo].gif -fe test-003[manggo].gif -fe test-004[manggo].gif

echo 'Tagging all .bin files inside bin directory with a tag.'
mkdir -p bin
touch 'bin/test-001.bin'
touch 'bin/test-002.bin'
touch 'bin/test-003.bin'
touch 'bin/test-004.bin'
output=$(cat <<-EOF
${PWD}/bin/test-001[orange].bin
${PWD}/bin/test-002[orange].bin
${PWD}/bin/test-003[orange].bin
${PWD}/bin/test-004[orange].bin
EOF
)
tester "ls bin/*.bin | tag add orange" -o "$output" -fe bin/test-001[orange].bin -fe bin/test-002[orange].bin -fe bin/test-003[orange].bin -fe bin/test-004[orange].bin

echo 'Tagging all files inside exe directory with a tag and make sure the -d options is require.'
mkdir -p exe
touch 'exe/test-001.exe'
touch 'exe/test-002.exe'
touch 'exe/test-003.exe'
touch 'exe/test-004.exe'
output=$(cat <<-'EOF'
exe/test-001[apple].exe
exe/test-002[apple].exe
exe/test-003[apple].exe
exe/test-004[apple].exe
EOF
)
tester "ls exe/ | tag add apple -d exe/" -o "$output" -fe exe/test-001[apple].exe -fe exe/test-002[apple].exe -fe exe/test-003[apple].exe -fe exe/test-004[apple].exe

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

read -rsn1 -p "Delete directory temporary? [y/n]" option

if [[ $option == y ]];then
    cd ..
    rm -rf temporary/
    echo " "Deleted.
fi
