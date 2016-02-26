#
# AR-P buildsystem smart Makefile
#
package[[ target_a52dec

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 0.7.4
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://liba52.sourceforge.net/files/${PN}-${PV}.tar.gz
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = liba52 is a free library for decoding ATSC A/52 streams. It is released under the terms of the GPL license
PACKAGES_${P} = liba52 a52dec

RDEPENDS_liba52 = libc6
define postinst_liba52
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_liba52 = /usr/lib/liba52.so.*

RDEPENDS_a52dec = liba52 libc6
FILES_a52dec = /usr/bin/*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
