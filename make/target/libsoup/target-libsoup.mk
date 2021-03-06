#
# AR-P buildsystem smart Makefile
#
package[[ target_libsoup

BDEPENDS_${P} = $(target_glib2)

PV_${P} = 2.53.2
PR_${P} = 1

call[[ base ]]

rule[[
  extract:https://download.gnome.org/sources/${PN}/2.53/${PN}-${PV}.tar.xz
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			--disable-more-warnings \
			--enable-vala=no \
			--without-gnome \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = libsoup is an HTTP client/server library

RDEPENDS_${P} = libz1 libxml2 libffi6 libsqlite3 libc6 libglib
FILES_${P} = /usr/lib/*.so.*
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
