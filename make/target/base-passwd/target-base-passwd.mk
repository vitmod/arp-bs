#
# AR-P buildsystem smart Makefile
#
package[[ target_base_passwd

BDEPENDS_${P} = $(target_filesystem) $(target_glibc)

PR_${P} = 2

PV_${P} = 3.5.9-13
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]

DESCRIPTION_${P} = This package supplies the "master" copies of /etc/passwd and /etc/group, \
in /usr/share/base-passwd. It also supplies the utility "update-passwd", \
which automatically makes sure that uids and gids in the 0-99 range on \
your system are consistent with the Debian master copies. This means \
that all entries in the masterfiles in that range have to be present on \
your system, and only those entries. The reason for not allowing other \
entries is that Debian reserves that range for future use.

define postinst_${P}
#!/bin/sh
update-passwd -L \
-p $$OPKG_OFFLINE_ROOT/usr/share/base-passwd/passwd.master \
-g $$OPKG_OFFLINE_ROOT/usr/share/base-passwd/group.master \
-P $$OPKG_OFFLINE_ROOT/etc/passwd \
-S $$OPKG_OFFLINE_ROOT/etc/shadow \
-G $$OPKG_OFFLINE_ROOT/etc/group
endef

call[[ ipkbox ]]

]]package
