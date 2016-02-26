#
# AR-P buildsystem smart Makefile
#
package[[ target_libcap

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 2.22
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://mirror.linux.org.au/linux/libs/security/linux-privs/${PN}2/${PN}-${PV}.tar.bz2
  patch:file://fix-CAP_LAST_CAP.patch
]]rule

call[[ base_do_prepare ]]

MAKE_FLAGS_${P} = \
	DESTDIR=$(PKDIR) \
	LIBDIR=$(PKDIR)/lib \
	PAM_CAP=no \
	LIBATTR=no \
	CC=$(target)-gcc \
	BUILD_CC=gcc

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && $(run_make) ${MAKE_FLAGS}
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) ${MAKE_FLAGS} install
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Library for getting/setting POSIX.1e capabilities
PACKAGES_${P} = libcap2 libcap_bin

RDEPENDS_libcap2 = libc6
define postinst_libcap2
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_libcap2 = /lib/*.so.*

RDEPENDS_libcap_bin = libc6 libcap2
FILES_libcap_bin = /sbin/*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
