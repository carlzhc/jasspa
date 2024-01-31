dict=enus
nodename=$(shell uname -n)
os=ubuntu-20-x86_64
ifeq ($(nodename),bariuke)
	os := fedora-38-x86_64
endif
ifeq ($(nodename),ubuntu18)
	os=ubuntu-18-x86_64
endif

ifeq ($(nodename),guitar)
	os=fedora-30-x86_64
endif
	
default:
	echo "Makefile for Linux systems"
	echo "Usage make bfs-bin|me-bin|me-standalone"
bfs-bin: bin/bfs
bin/bfs:
	cd bfs && make
	cp bfs/bfs bin/
me-bin:
	cd src && make -f linux32gcc.gmk
	find src -type f -perm 755 -name 'me*' -exec cp -vf {} bin/ \;

me-bfs:
	-rm -rf me-bfs/*
	-mkdir me-bfs
	-mkdir me-bfs/jasspa
	-mkdir me-bfs/jasspa/spelling
	cp -r jasspa/macros me-bfs/jasspa/
	rm -f me-bfs/jasspa/macros/*~
	rm -f me-bfs/jasspa/macros/*.bak
	-rm me-bfs/jasspa/macros/null
	cp -r jasspa/contrib me-bfs/jasspa/
	cp jasspa/spelling/*$(dict)*f me-bfs/jasspa/spelling/
	find src -maxdepth 1 -type f -perm 755 -name 'me*' -exec cp -vf {} bin/ \;
	[ -f bin/mecw.exe] && (cd me-bfs && ../bin/bfs -a ../bin/mecw.exe -o ../bin/mecw-windows.exe ./jasspa) ||:
	[ -f bin/mew32.exe ] && (cd me-bfs && ../bin/bfs -a ../bin/mew32.exe -o ../bin/me32-windows.exe ./jasspa) ||:
	[ -f bin/mec32.exe ] && (cd me-bfs && ../bin/bfs -a ../bin/mec32.exe -o ../bin/mec32-windows.exe ./jasspa) ||:
	[ -f bin/mec.exe ] && (cd me-bfs && ../bin/bfs -a ../bin/mec.exe -o ../bin/mec-windows.exe ./jasspa) ||:
	[ -f bin/mec -a ! -f bin/mec.exe ] && (cd me-bfs && ../bin/bfs -a ../bin/mec -o ../bin/mec-linux.bin ./jasspa) ||:
	[ -f bin/me*-windows.exe ] || [ -f bin/me*-linux.bin ]

me-bfs-bin: me-bfs
	cd me-bfs && ../bin/bfs -a ../src/.win32mingw-release-mew/mew32.exe -o ../me-windows.exe ./jasspa
	cd me-bfs && ../bin/bfs -a ../src/.win32mingw-release-mec/mec32.exe -o ../mec-windows.exe ./jasspa
	#rm -rf me-bfs/*
mingw-w32-compile:
	cd src && make -f win32mingw.mak CC=i686-w64-mingw32-gcc RC=i686-w64-mingw32-windres
	cd src && make -f win32mingw.mak CC=i686-w64-mingw32-gcc RC=i686-w64-mingw32-windres BTYP=c
mingw-w32-run:	
	cd src && MEPATH=Z:/home/groth/workspace/microemacs/jasspa/macros wine ./.win32mingw-release-mew/mew32.exe
app-image:
	chmod 755 jme.AppDir/AppRun
	rm -rf jasspa-bfs
	cp -r jasspa jasspa-bfs
	cp -r jasspa/spelling jme.AppDir/usr/share/
	rm -rf jasspa-bfs/contrib
	rm -rf jasspa-bfs/company
	rm -rf jasspa-bfs/pixmaps
	rm -rf jasspa-bfs/spelling
	rm -f jasspa-bfs/macros/*~
	rm -f jasspa-bfs/macros/*.bak
	./bin/bfs -a bin/mecw-ubuntu-18 -o jme.AppDir/usr/bin/jme ./jasspa-bfs
	appimagetool-x86_64.AppImage jme.AppDir
	./Jasspa_MicroEmacs-x86_64.AppImage -V -n
	#rm -rf jasspa-bfs
docu-html:
	tclsh bin/ehf2md.tcl jasspa/macros/me.ehf files.txt htm
	for file in `ls htm/*.md` ; do pandoc $$file -f gfm -o htm/`basename $$file .md`.htm -s --css null.css; done
run-tuser:
	MENAME=tuser MEPATH=`pwd`/tuser:`pwd`/jasspa/macros src/.linux32gcc-release-mecw/mecw

msys2-bin/bfs:
	mkdir -p $(@D)
	cd bfs && make
	cp bfs/bfs $@

msys msys2: msys2-bin/bfs
	cd src && ./build
	-rm -rf msys2-me-bfs/*
	-mkdir msys2-me-bfs
	-mkdir msys2-me-bfs/jasspa
	-mkdir msys2-me-bfs/jasspa/spelling
	cp -r jasspa/macros msys2-me-bfs/jasspa/
	rm -f msys2-me-bfs/jasspa/macros/*~
	rm -f msys2-me-bfs/jasspa/macros/*.bak
	-rm msys2-me-bfs/jasspa/macros/null
	cp -r jasspa/contrib msys2-me-bfs/jasspa/
	cp jasspa/spelling/*$(dict)*f msys2-me-bfs/jasspa/spelling/
	find src -maxdepth 1 -type f -perm 755 -name 'me*' -exec cp -vf {} msys2-bin/ \;
	[ -f msys2-bin/mecw.exe] && (cd msys2-me-bfs && ../msys2-bin/bfs -a ../msys2-bin/mecw.exe -o ../msys2-bin/mecw-windows.exe ./jasspa) ||:
	[ -f msys2-bin/mew32.exe ] && (cd msys2-me-bfs && ../msys2-bin/bfs -a ../msys2-bin/mew32.exe -o ../msys2-bin/me32-windows.exe ./jasspa) ||:
	[ -f msys2-bin/mec32.exe ] && (cd msys2-me-bfs && ../msys2-bin/bfs -a ../msys2-bin/mec32.exe -o ../msys2-bin/mec32-windows.exe ./jasspa) ||:
	[ -f msys2-bin/mec.exe ] && (cd msys2-me-bfs && ../msys2-bin/bfs -a ../msys2-bin/mec.exe -o ../msys2-bin/mec-windows.exe ./jasspa) ||:
	[ -f msys2-bin/mec -a ! -f msys2-bin/mec.exe ] && (cd msys2-me-bfs && ../msys2-bin/bfs -a ../msys2-bin/mec -o ../msys2-bin/mec-linux.bin ./jasspa) ||:
	[ -f msys2-bin/me*-windows.exe ] || [ -f msys2-bin/me*-linux.bin ]
