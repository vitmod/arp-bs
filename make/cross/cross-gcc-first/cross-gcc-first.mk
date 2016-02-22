#
# CROSS GCC
#
package[[ cross_gcc_first

BDEPENDS_${P} = $(target_kernel_headers) $(target_glibc_headers) $(cross_mpc) $(cross_libelf)

PR_${P} = 1

ifdef CONFIG_GCC48
 ST_PV_${P} = 4.8.4
 ST_PR_${P} = 139
else
 ST_PV_${P} = 4.7.3
 ST_PR_${P} = 124
endif
PV_${P} := ${ST_PV}-${ST_PR}

ST_PN_${P} = cross-gcc
${P}_SPEC = stm-${ST_PN}.spec
${P}_SPEC_PATCH = $(${P}_SPEC).$(PV_${P}).first.diff
${P}_PATCHES = stm-${ST_PN}.$(PV_${P}).diff
${P}_SRCRPM = $(archivedir)/$(STLINUX)-${ST_PN}-$(PV_${P}).src.rpm

# NAME_${P} = libgcc1
# DESCRIPTION_${P} =  The GNU cc and gcc C compilers.
# FILES_${P} = /lib/libgcc_s*

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]

#call[[ rpm_do_compile ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(rpm_src_install) $(${P}_SRCRPM)
	$(if $(${P}_SPEC_PATCH), cd $(specsprefix) && patch -p1 $(${P}_SPEC) < ${SDIR}/$(${P}_SPEC_PATCH) )
	$(if $(${P}_PATCHES), cp $(addprefix ${SDIR}/,$(${P}_PATCHES)) $(sourcesprefix) )
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	$(rpm_build) $(specsprefix)/$(${P}_SPEC)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	
	rm -f $(PKDIR)/$(crossprefix)/lib/libiberty.a
	touch $@

]]package