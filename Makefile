PREFIX=/usr
MANDIR=$(PREFIX)/share/man
BINDIR=$(PREFIX)/bin

all:
	@echo "Run 'make install' to install x86routertools."
	@echo "Run 'make uninstall' to remove x86routertools."
	@echo ""
	@echo "Edit Makefile to customize installation paths."

install:
	@install -Dm755 routertools $(DESTDIR)$(BINDIR)/routertools
	@install -Dm644 systemd/routertoolsd-inet.service $(DESTDIR)$(PREFIX)/lib/systemd/system/routertoolsd-inet.service 
	@install -Dm644 systemd/routertoolsd-wifi@.service $(DESTDIR)$(PREFIX)/lib/systemd/system/routertoolsd-wifi@.service 
	@install -Dm644 README.md $(DESTDIR)$(PREFIX)/share/doc/x86routertools/README.md 
	@- routertools -qF
	@echo "If you get error 1 (ignored), it's normal. Routertools was installed."
uninstall:
	@rm -f $(DESTDIR)$(BINDIR)/routertools
	@[ ! -f /lib/systemd/system/routertoolsd-inet.service ] || rm -f $(DESTDIR)$(PREFIX)/lib/systemd/system/routertoolsd-inet.service
	@[ ! -f /lib/systemd/system/routertoolsd-wifi@.service ] || rm -f $(DESTDIR)$(PREFIX)/lib/systemd/system/routertoolsd-wifi@.service
	@rm -f $(DESTDIR)$(PREFIX)/share/doc/x86routertools/README.md
	@echo "Uninstalled routertools"
