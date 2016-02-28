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
DESCRIPTION_${P} = t any moment, a running System V is in one of the predetermined number of states, called runlevels. \
At least one runlevel is the normal operating state of the system; typically, other runlevels represent single-user mode \
(used for repairing a faulty system), system shutdown, and various other states. Switching from one runlevel to another \
auses a per-runlevel set of scripts to be run, which typically mount filesystems, start or stop daemons,\
start or stop the X Window System, shutdown the machine, etc.

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
