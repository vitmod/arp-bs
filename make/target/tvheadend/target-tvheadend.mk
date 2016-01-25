#
# TVHEADEND
#
# AR-P buildsystem smart Makefile
#

package[[ target_tvheadend

BDEPENDS_${P} = $(target_glibc)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://github.com/tvheadend/tvheadend.git
  nothing:file://tvheadend
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-avahi \
			--disable-tvhcsa \
			--disable-libav \
			--disable-dvben50221 \
			--disable-dbus_1 \
			$(PLATFORM_CPPFLAGS) \
			&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	$(INSTALL_DIR) $(PKDIR)/etc/init.d
	$(INSTALL_BIN) $(DIR_${P})/tvheadend $(PKDIR)/etc/init.d/tvheadend

	touch $@

call[[ ipk ]]

PACKAGES_${P} = tvheadend tvheadend_init
DESCRIPTION_${P} = tvheadend
RDEPENDS_tvheadend = libc6 tvheadend_init

FILES_tvheadend = \
	/usr/bin/tvheadend \
	/usr/share/tvheadend/*

FILES_tvheadend_init = \
	/etc/init.d/tvheadend

define postinst_tvheadend_init
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ tvheadend start 90 S .
endef

define prerm_tvheadend_init
#!/bin/sh
update-rc.d -f -r $$OPKG_OFFLINE_ROOT/ tvheadend remove
endef

call[[ ipkbox ]]

]]package
