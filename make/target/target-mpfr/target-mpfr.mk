#
# AR-P buildsystem smart Makefile
#
package[[ target_mpfr

BDEPENDS_${P} = $(target_gmp)

PR_${P} = 1

PV_${P} = 3.1.2-10
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

]]package
