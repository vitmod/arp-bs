#
# HOST AUTOCONF
#
package[[ host_autoconf

BDEPENDS_${P} = $(host_rpmconfig) $(host_autotools)

PR_${P} = 1

PV_${P} = 2.64-6
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = stm-$(${P}).$(PV_${P}).spec.diff
${P}_PATCHES = stm-$(${P}).$(PV_${P}).diff
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]
call[[ rpm ]]

]]package