#
# AR-P buildsystem smart Makefile
#
package[[ target_glibc_second

BDEPENDS_${P} = $(target_zlib) $(target_libelf)
BREMOVES_${P} = $(target_glibc_first)

PR_${P} = 2

call[[ target_glibc_in ]]

call[[ base ]]
call[[ base_rpm ]]

DO_PACKAGE_${P} = $(target)-strip $(PKDIR)/sbin/ldconfig

call[[ rpm ]]

call[[ ipk ]]

PACKAGES_${P} = libc6

DESCRIPTION_libc6 = ${P}
define postinst_libc6
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_libc6 = \
	/etc/ld.so.conf \
	/lib/*.s* \
	/sbin/ldconfig

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
