PREFIX = /usr
COMMANDS = spruce

all:
	echo No build needed.

install:
	install -m 755 -d $(DESTDIR)$(PREFIX)/bin
	install -m 755 $(COMMANDS) $(DESTDIR)$(PREFIX)/bin

check:
	echo "Note: the self-test does not yet pass"
	sh ./test-spruce.sh
