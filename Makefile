deb:
	fakeroot dpkg-buildpackage -tc -us -uc

check:
	lintian ../*.deb

all: deb check

.PHONY: all
