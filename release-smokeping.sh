#!/bin/sh
set -e
VERSION=`perl -n -e 'm/\QAC_INIT([rrdtool],[\E(.+?)\Q])\E/ && print $1' configure.ac`
svn commit -m "preparing for the release of smokeping-$VERSION"
cd /tmp
svn export svn://svn.oetiker.ch/smokeping/trunk/software smokeping-$$
cd smokeping-$$
mkdir conftools
aclocal
autoconf
automake -a -c
./setup/build-perl-modules.sh /tmp/smokeping-$$-build/thirdparty
./configure  --enable-maintainer-mode --prefix=/tmp/smokeping-$$-build PERL5LIB=/scratch/oetiker/rrd-dev/lib/perl
make dist
scp smokeping-$VERSION.tar.gz oposs@james:public_html/smokeping/pub
cd /tmp
rm -r smokeping-$$*
svn copy -m "tagging version $VERSION" svn://svn.oetiker.ch/smokeping/trunk/software svn://svn.oetiker.ch/smokeping/tags/$VERSION
