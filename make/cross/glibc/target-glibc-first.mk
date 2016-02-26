#
# CROSS GLIBC
#
package[[ target_glibc_first

BDEPENDS_${P} = $(cross_gcc_first)
BREMOVES_${P} = $(target_glibc_headers)

PR_${P} = 1

PV_${P} = 2.14.1-51

${P}_SPEC = stm-target-glibc.spec
${P}_SPEC_PATCH = $(${P}_SPEC).diff
${P}_PATCHES = make-versions-4.0-and-greater.patch
${P}_SRCRPM = $(archivedir)/$(STLINUX)-target-glibc-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ ipk ]]

#call[[ rpm_do_compile ]]

$(TARGET_${P}).do_prepare: $(${P}_SRCRPM)
	$(rpm_src_install) $(${P}_SRCRPM)
	$(if $(${P}_SPEC_PATCH), cd $(specsprefix) && patch -p1 $(${P}_SPEC) < ${SDIR}/$(${P}_SPEC_PATCH) )
	$(if $(${P}_PATCHES), cp $(addprefix ${SDIR}/,$(${P}_PATCHES)) $(sourcesprefix) )
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	$(rpm_build) $(specsprefix)/$(${P}_SPEC)
	touch $@

# $(TARGET_${P}): $(TARGET_${P}).do_ipk
# 	opkg $(target_ipkg_args) remove $(target_glibc_headers)
# 	opkg $(target_ipkg_args) install $(IPK_${P})
# 	touch $@

call[[ rpm_do_package ]]

]]package