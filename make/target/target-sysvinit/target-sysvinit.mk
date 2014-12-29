#
# AR-P buildsystem smart Makefile
#
package[[ target_sysvinit

BDEPENDS_${P} = $(target_filesystem) $(target_glibc)

PR_${P} = 1

PV_${P} = 2.86-15
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

NAME_${P} = ${PN}
FILES_${P} = \
	/sbin/fsck.nfs \
	/sbin/killall5 \
	/sbin/init \
	/sbin/halt \
	/sbin/poweroff \
	/sbin/shutdown \
	/sbin/reboot

call[[ ipkbox ]]

]]package
