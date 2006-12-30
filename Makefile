deb:
	fakeroot dpkg-buildpackage -tc 

check:
	lintian ../*.deb

all: deb check

.PHONY: all
