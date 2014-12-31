#
# AR-P buildsystem smart Makefile
#
package[[ target_glibc

BDEPENDS_${P} = $(target_zlib) $(target_libelf)
BREMOVES_${P} = $(target_glibc_first)

PR_${P} = 2

PV_${P} := 2.14.1-53
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = $(${P}_SPEC).diff
${P}_PATCHES = make-versions-4.0-and-greater.patch
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

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

call[[ ipkbox ]]

]]package
