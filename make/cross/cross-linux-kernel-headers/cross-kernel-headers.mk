#
# CROSS KERNEL HEADERS
#

# assume gcc depends on common headers for all targets
package[[ target_kernel_headers

BDEPENDS_${P} = $(target_filesystem)

PR_${P} = 2

PV_${P} = 2.6.32.46-47
${P}_SPEC = stm-target-${PN}-kbuild.spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-target-linux-${PN}-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]

call[[ rpm ]]

]]package
