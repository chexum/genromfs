#!/bin/sh

# requires: GNU md5sum and bash, xxd from vim
# known bug: file ordering is not actually specified

NTESTS=9
FAIL=0
I=0
V=
tdir=`pwd`
CMD=$tdir/../genromfs
mkdir testimg
cd testimg

function testlabel () {
  I=`expr $I + 1`
  echo "$I/$NTESTS" "$@"
  rm -f *
  rm -f $tdir/img.bin
}

function testsummary () {
  xxd -a <$tdir/img.bin >$tdir/$I.out
  if ! diff -u $tdir/$I.ok $tdir/$I.out; then
    echo FAILED - Check differences above
    FAIL=`expr $FAIL + 1`
  else
    echo OK
    rm -f $tdir/$I.out
  fi
}

testlabel Test image with no files
eval $CMD $V -V EMPTY -f $tdir/img.bin
testsummary

testlabel Test image with a single file
echo dummy >dummy
eval $CMD $V -V SINGLEFILE -f $tdir/img.bin
testsummary

testlabel Test image with a hard links
echo dummy >dummy
ln dummy hardlink
eval $CMD $V -V HARDLINK -f $tdir/img.bin
testsummary

testlabel Test image with alignment
echo t01abc >t01xyz
echo '(512aligned0123456789abcdef)' >t02uvw
echo t03ghi >t03rst
eval $CMD $V -V ALIGNED -A '512,t02*' -f $tdir/img.bin
testsummary

testlabel Test image with alignment with absolute path
echo t01abc >t01xyz
echo t02def >t02uvw
echo '(128aligned0123456789abcdef)' >t03_123aligned
eval $CMD $V -V ABSALIGNED -A '128,/t03*' -f $tdir/img.bin
testsummary

testlabel Test image with file data
echo 01230123www1012 >rom1a.txt
echo 01230123www1012 >rom1b.txt
eval $CMD $V -V EXTDATA -f $tdir/img.bin
testsummary

testlabel Test default alignment
echo 0123 >abc.txt
echo 4567 >def.txt
eval $CMD $V -V DEFALIGNED -a128 -f $tdir/img.bin
testsummary

testlabel Test multiple alignment
echo boot512 >m68k.boot
echo boot2048 >sparc.boot
eval $CMD $V -V MULTIALIGNED -A2048,*.boot -A1024,m68k.boot -A512,m68k.boot -f $tdir/img.bin
testsummary

testlabel Test excludes
echo unwanted >alpha
echo needed >beta
echo unwanted >gamma
eval $CMD $V -V EXCLUDES -x '"*a*a"' -f $tdir/img.bin
testsummary

# remove stray files
rm -f *

# end
echo $FAIL failures found
cd $tdir
rm -f img.bin
rmdir testimg
