#!/bin/sh
# https://github.com/zotero/cross-xpdf/blob/master/Dockerfile

fetch https://dl.xpdfreader.com/old/xpdf-4.03.tar.gz
fetch https://poppler.freedesktop.org/poppler-data-0.4.10.tar.gz

fetch https://raw.githubusercontent.com/zotero/cross-xpdf/master/GlobalParams.cc
fetch https://raw.githubusercontent.com/zotero/cross-xpdf/master/GlobalParams.h
fetch https://raw.githubusercontent.com/zotero/cross-xpdf/master/cmake-config.txt
fetch https://raw.githubusercontent.com/zotero/cross-xpdf/master/gfile.cc
fetch https://raw.githubusercontent.com/zotero/cross-xpdf/master/gfile.h
fetch https://raw.githubusercontent.com/zotero/cross-xpdf/master/pdftotext.cc

rm -rf build/xpdf build/xpdf/build build/pdftools
mkdir -p build/xpdf build/xpdf/build build/pdftools

tar -xf xpdf-4.03.tar.gz -C build/xpdf --strip-components=1

patch -s -d build/xpdf -i ~/zotero-xpdf/patch-xpdf_pdfinfo.cc

cp pdftotext.cc		build/xpdf/xpdf/pdftotext.cc
cp GlobalParams.h	build/xpdf/xpdf/GlobalParams.h
cp GlobalParams.cc	build/xpdf/xpdf/GlobalParams.cc
cp gfile.h		build/xpdf/goo/gfile.h
cp gfile.cc		build/xpdf/goo/gfile.cc
cp cmake-config.txt	build/xpdf/cmake-config.txt

cd build/xpdf/build

cmake -DCMAKE_BUILD_TYPE=release \
	-DCMAKE_DISABLE_FIND_PACKAGE_Qt4:BOOL=ON \
	-DUSE_LCMS:BOOL=OFF \
	-DNO_TEXT_SELECT:BOOL=OFF \
	-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Widgets:BOOL=ON \
	-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Widgets:BOOL=ON \
	..

make -j8

cd ../../..

cp build/xpdf/build/xpdf/pdftotext build/pdftools
cp build/xpdf/build/xpdf/pdfinfo   build/pdftools

mkdir -p build/poppler-data build/pdftools/poppler-data
tar -xf poppler-data-0.4.10.tar.gz -C build/poppler-data --strip-components=1
cp -r build/poppler-data/cidToUnicode		build/pdftools/poppler-data
cp -r build/poppler-data/cMap			build/pdftools/poppler-data
cp -r build/poppler-data/nameToUnicode	build/pdftools/poppler-data
cp -r build/poppler-data/unicodeMap		build/pdftools/poppler-data
cp -r build/poppler-data/COPYING		build/pdftools/poppler-data
cp -r build/poppler-data/COPYING.adobe	build/pdftools/poppler-data
cp -r build/poppler-data/COPYING.gpl2		build/pdftools/poppler-data

#tar -cvzf ../pdftools.tar.gz *

