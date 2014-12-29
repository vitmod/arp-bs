#
# CROSS BINUTILS
#
package[[ cross_binutils

BDEPENDS_${P} = $(cross_filesystem)

PR_${P} = 1

PV_${P} = 2.23.2-72
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = $(${P}_SPEC).$(PV_${P}).diff
${P}_PATCHES = stm-$(${P}).$(PV_${P}).diff
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]
call[[ rpm ]]

]]package