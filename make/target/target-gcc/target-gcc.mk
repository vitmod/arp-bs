#
# AR-P buildsystem smart Makefile
#
package[[ target_gcc

BDEPENDS_${P} = $(target_filesystem) $(target_glibc) $(target_zlib) $(target_mpc) $(target_libelf)
BREMOVES_${P} = $(target_cross_gcc_lib)

PR_${P} = 1

ifdef CONFIG_GCC48
 ST_PV_${P} = 4.8.4
 ST_PR_${P} = 149
else
 ST_PV_${P} = 4.7.3
 ST_PR_${P} = 129
endif
PV_${P} := ${ST_PV}-${ST_PR}

${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = $(${P}_SPEC).$(PV_${P}).diff
${P}_PATCHES = stm-$(${P}).$(PV_${P}).diff
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]

call[[ ipk ]]

# Provides libs that comes with gcc
call[[ target_gcc_lib_in ]]

call[[ ipkbox ]]

]]package
