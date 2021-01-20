PREFIX=/usr/local

xkcdl: xkcdl.sh
    cat xkcdl.sh > $@
    chmod +x $@

test: xkcdl.sh
    shellcheck -s sh xkcdl.sh

clean:
    rm -f xkcdl

install: xkcdl
    mkdir -p $(DESTDIR)$(PREFIX)/bin
    cp -f xkcdl $(DESTDIR)$(PREFIX)/bin
    chmod 755 $(DESTDIR)$(PREFIX)/bin/xkcdl

uninstall:
    rm -f $(DESTDIR)$(PREFIX)/bin/xkcdl

.PHONY: test clean install uninstall
