#
# AR-P buildsystem smart Makefile
#
package[[ target_orc

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 0.4.23
PR_${P} = 1

DESCRIPTION_${P} = ORC - The Oil Runtime Compiler is a library and simple set of tools for compiling and executing simple programs.

call[[ base ]]

rule[[
  extract:http://gstreamer.freedesktop.org/src/${PN}/${PN}-${PV}.tar.xz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
		&& \
		$(run_make)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

PACKAGES_${P} = liborc orc liborc_test

RDEPENDS_liborc = libc6
define postinst_liborc
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_liborc = /usr/lib/liborc*.so.*

RDEPENDS_liborc_test = liborc libc6
define postinst_liborc_test
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_liborc_test = /usr/lib/liborc-test*.so.*

RDEPENDS_orc = liborc liborc_test libc6
FILES_orc = /usr/bin/*

call[[ ipkbox ]]

]]package
