#
# HOST-MTD-UTILS
#
package[[ host_module_init_tools

BDEPENDS_${P} = $(host_rpmconfig) $(host_autotools)

PR_${P} = 2

PV_${P} = 3.16-3
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = stm-$(${P}).spec.diff
${P}_PATCHES = ${PN}-no-man.patch
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]
call[[ rpm ]]

]]package