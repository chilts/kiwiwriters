deb:
	fakeroot dpkg-buildpackage

check:
	lintian ../*.deb

all: deb check

.PHONY: all
