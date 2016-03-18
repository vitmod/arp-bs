#
# AR-P buildsystem smart Makefile
#
package[[ target_gdb

BDEPENDS_${P} = $(target_filesystem)

PR_${P} = 1

PV_${P} = 7.6-51
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]

call[[ ipk ]]

PACKAGES_${P} = gdb gdbserver
DESCRIPTION_${P} = gdb gdbserver

RDEPENDS_gdb = libc6 libexpat1
FILES_gdb = /usr/bin/gdb

RDEPENDS_gdbserver = libc6
FILES_gdbserver = /usr/bin/gdbserver

call[[ ipkbox ]]

]]package
