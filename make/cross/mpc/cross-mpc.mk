#
# HOST AUTOMAKE
#
package[[ cross_mpc

BDEPENDS_${P} = $(cross_mpfr)

PR_${P} = 1

PV_${P} = 1.0.2-7
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = 
${P}_PATCHES = 
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]
call[[ rpm ]]

]]package