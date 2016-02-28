#
# CROSS GLIBC
#
package[[ target_glibc_first

BDEPENDS_${P} = $(cross_gcc_first)
BREMOVES_${P} = $(target_glibc_headers)

PR_${P} = 1

call[[ target_glibc_in ]]

call[[ base ]]
call[[ base_rpm ]]

call[[ rpm ]]

call[[ ipk ]]

]]package