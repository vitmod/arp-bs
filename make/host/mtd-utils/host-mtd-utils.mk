#
# HOST-MTD-UTILS
#
package[[ host_mtd_utils

BDEPENDS_${P} = $(host_rpmconfig) $(host_autotools)

PR_${P} = 1

PV_${P} = 1.0.1-8
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = 
${P}_PATCHES = 
${P}_SRCRPM = $(archivedir)/stlinux23-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]

call[[ ipk ]]

]]package