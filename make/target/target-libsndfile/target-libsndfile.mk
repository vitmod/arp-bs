#
# AR-P buildsystem smart Makefile
#
package[[ target_libsndfile

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 1.0.25
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://www.mega-nerd.com/${PN}/files/${PN}-${PV}.tar.gz
  patch:file://0001-src-sd2.c-Fix-segfault-in-SD2-RSRC-parser.patch
  patch:file://0001-src-sd2.c-Fix-two-potential-buffer-read-overflows.patch
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix=/usr \
			--disable-external-libs \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libsndfile1
DESCRIPTION_${P} = An audio format Conversion library

RDEPENDS_${P} = libc6 libgcc1
FILES_${P} = /usr/lib/*.so.*
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
