#
# AR-P buildsystem smart Makefile
#
package[[ target_mpc

BDEPENDS_${P} = $(target_mpfr)

PR_${P} = 1

PV_${P} = 1.0.1-5
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

]]package
