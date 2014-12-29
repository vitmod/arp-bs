#
# HOST AUTOMAKE
#
package[[ host_automake

BDEPENDS_${P} = $(host_opkg_meta) $(host_rpmconfig) $(host_autotools)

PR_${P} = 1

PV_${P} = 1.11.1-3
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]
call[[ rpm ]]

]]package