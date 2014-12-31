#
# HOST-RPMCONFIG
#
package[[ host_rpmconfig

BDEPENDS_${P} = $(host_opkg_meta) ##$(host_make)
DEPENDS_${P} = $(host_rpmlocalmacros)

PR_${P} = 2

PV_${P} = 2.4-33
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH = $(${P}_SPEC).$(PV_${P}).diff
${P}_PATCHES = stm-$(${P})-$(PV_${P})-ignore-skip-cvs-errors.patch \
               stm-$(${P})-$(PV_${P})-autoreconf-add-libtool-macros.patch
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm_do_prepare ]]
call[[ rpm_do_compile ]]

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	install -d $(PKDIR)/$(hostprefix)/
	mv $(PKDIR)/opt/STM/STLinux-2.4/* $(PKDIR)/$(hostprefix)/
	rm -rf $(PKDIR)/opt
	touch $@

call[[ ipk ]]

]]package