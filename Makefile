PREFIX ?= /usr/local
install:
	install -D -m755 bin/ec-ladder-override $(DESTDIR)$(PREFIX)/sbin/ec-ladder-override
	install -D -m755 hooks/acpi-override $(DESTDIR)$(PREFIX)/share/dell-ec-ladder-override/acpi-override
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/sbin/ec-ladder-override
	rm -rf $(DESTDIR)$(PREFIX)/share/dell-ec-ladder-override
test:
	tests/corpus.sh $(CORPUS) Dell
.PHONY: install uninstall test
