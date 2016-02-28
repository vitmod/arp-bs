#
# LIBS FROM GCC
#

# This is a solution for the case, when we have packages for cross and target
# from the same build dir
# There is NO reason in splitting toolchain ipk's when they goes to same SYSROOT.
package[[ target_cross_gcc_lib

BDEPENDS_${P} = $(cross_gcc_second)

PR_${P} = 1

call[[ gcc_in ]]

call[[ base ]]

# packaged from cross-gcc
$(TARGET_${P}).do_package: $(cross_gcc_second).do_package
	$(PKDIR_clean)
	cp -ar $(WORK_cross_gcc_second)/root/$(targetprefix)/* $(PKDIR)
	touch $@

# Ask to not RM_WORK util we finished
$(TARGET_cross_gcc_second): $(TARGET_${P}).do_package

call[[ ipk ]]

ifdef CONFIG_GCC_LIB_FROM_CROSS
SRC_URI_${P} = $(SRC_URI_cross_gcc_second)
call[[ target_gcc_lib_in ]]
call[[ ipkbox ]]
endif

]]package
