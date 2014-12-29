#
# AR-P buildsystem smart Makefile
#
package[[ target_gmp

BDEPENDS_${P} = $(target_filesystem) $(cross_gcc_second)

PR_${P} = 1

PV_${P} = 5.1.3-10
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]

call[[ ipk ]]

]]package
