#
# AR-P buildsystem smart Makefile
#
package[[ target_minidlna

BDEPENDS_${P} = $(target_ffmpeg) $(target_flac) $(target_sqlite) $(target_libogg) $(target_libid3tag) $(target_libvorbis) $(target_libexif)  $(target_libjpeg_turbo)

PV_${P} = 1.1.5
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://sourceforge.net/projects/${PN}/files/${PN}/${PV}/${PN}-${PV}.tar.gz
  patch:file://${PN}-${PV}.patch
  nothing:file://minidlna-init
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./autogen.sh && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-nls \
			&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	
	$(INSTALL_DIR) $(PKDIR)/etc && \
	$(INSTALL_DIR) $(PKDIR)/etc/init.d && \
	$(INSTALL_FILE) $(DIR_${P})/minidlna.conf $(PKDIR)/etc/minidlna.conf && \
	$(INSTALL_BIN) $(DIR_${P})/minidlna-init $(PKDIR)/etc/init.d/minidlna && \
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = "The MiniDLNA daemon is an UPnP-A/V and DLNA service which serves multimedia content to compatible clients on the network."
RDEPENDS_${P} = libexif12 libid3tag0 libflac8 libogg0 libjpeg-turbo libvorbis
define conffiles_${P}
/etc/minidlna.conf
endef
define postinst_${P}
#!/bin/sh
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-r $$D"
	else
		OPT="-s"
	fi
	update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ minidlna start 98 S .
fi
endef

define postrm_${P}
#!/bin/sh
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-r $$D"
	else
		OPT="-s"
	fi
	update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ minidlna remove
fi
endef

define preinst_${P}
#!/bin/sh
if [ -z "$$D" -a -f "/etc/init.d/minidlna" ]; then
	/etc/init.d/minidlna stop
fi
if type update-rc.d >/dev/null 2>/dev/null; then
	if [ -n "$$D" ]; then
		OPT="-f -r $$D"
	else
		OPT="-f"
	fi
	update-rc.d $$OPT $$OPKG_OFFLINE_ROOT/ minidlna remove
fi
endef

define prerm_${P}
#!/bin/sh
if [ -z "$ $$D" ]; then
	/etc/init.d/minidlna stop
fi
endef
FILES_${P} = /usr/lib/* \
		 /usr/sbin/* \
		 /etc/init.d/minidlna \
		 /etc/minidlna.conf

call[[ ipkbox ]]

]]package
