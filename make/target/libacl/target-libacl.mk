#
# AR-P buildsystem smart Makefile
#
package[[ target_libacl

BDEPENDS_${P} = $(target_glibc) $(target_libattr)

PR_${P} = 3

PV_${P} = 2.2.47-6
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

PACKAGES_${P} = acl libacl
DESCRIPTION_${P} = The acl package contains utilities to administer Access Control Lists, \
which are used to define more fine-grained discretionary access rights for files and directories. \
This package is known to build and work properly using an LFS-7.5 platform.

RDEPENDS_acl = libacl libc6
FILES_acl = /usr/bin

RDEPENDS_libacl = libc6
FILES_libacl = /usr/lib/libacl.so.*
define postinst_libacl
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
