#
# AR-P buildsystem smart Makefile
#
package[[ target_glibc

BDEPENDS_${P} = $(target_zlib) $(target_libelf)
BREPLACES_${P} = $(target_glibc_first) $(target_glibc_headers)

PR_${P} = 1

${P}_VERSION := 2.14.1-51
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = 
${P}_PATCHES = 
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(${P}_VERSION).src.rpm

call[[ base ]]
call[[ base_rpm ]]
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
	/lib/*.so.* \
	/sbin/ldconfig

call[[ ipkbox ]]

]]package
