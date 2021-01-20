PREFIX=/usr/local/bin

xkcdl: xkcdl.sh
	cat xkcdl.sh > $@
	chmod +x $@

test: xkcdl.sh
	shellcheck -s sh xkcdl.sh

clean:
	rm -f xkcdl

install: xkcdl
	mkdir -p $(PREFIX)/
	cp -f xkcdl $(PREFIX)/
	chmod 755 $(PREFIX)/xkcdl;

uninstall:
	rm -f $(PREFIX)/xkcdl

.PHONY: test clean install uninstall
