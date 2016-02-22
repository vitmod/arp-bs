#
# HOST-DISTRIBUTIONUTILS
#
package[[ host_distributionutils

BDEPENDS_${P} = $(host_opkg_meta) $(host_rpmconfig)

PR_${P} = 1

PV_${P} = 2.8.4-6
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]
call[[ rpm ]]

]]package