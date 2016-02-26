#
# Cross toolchain
#
package[[ meta_toolchain

BDEPENDS_${P} = $(target_glibc_second) $(cross_gcc_second) $(target_gcc_lib)

call[[ chain ]]

# If gcc/glibc version is updated, whole system must be rebuilt
${TARGET}: ${TARGET}.do_depends

# When clean removes all packages built with toolchain
${TARGET}.clean: ${TARGET}.clean_childs

]]package
