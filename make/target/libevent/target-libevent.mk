#
# AR-P buildsystem smart Makefile
#
package[[ target_libevent

BDEPENDS_${P} = $(target_glibc)

PR_${P} = 1

PV_${P} = 2.0.19-5
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = stm-$(${P}).spec.diff
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

PACKAGES_${P} = libevent libevent_core libevent_extra libevent_openssl libevent_pthreads

RDEPENDS_libevent = libc6
FILES_libevent = /usr/lib/libevent.s* /usr/lib/libevent-2.0.s*
define postinst_libevent
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libevent_core = libc6
FILES_libevent_core = /usr/lib/libevent_core.s* /usr/lib/libevent_core-2.0.s*
define postinst_libevent_core
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libevent_extra = libc6
FILES_libevent_extra = /usr/lib/libevent_extra.s* /usr/lib/libevent_extra-2.0.s*
define postinst_libevent_extra
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libevent_openssl = libc6
FILES_libevent_openssl = /usr/lib/libevent_openssl.s* /usr/lib/libevent_openssl-2.0.s*
define postinst_libevent_openssl
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

RDEPENDS_libevent_pthreads = libc6
FILES_libevent_pthreads = /usr/lib/libevent_pthreads.s* /usr/lib/libevent_pthreads-2.0.s*
define postinst_libevent_pthreads
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
