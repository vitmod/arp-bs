# for building rpms from stlinux
function[[ base_rpm

# place after variables definitions in *.mk file and before targets definitions
SRC_URI_${P} ?= stlinux.com
# only check file existance
$(TARGET_${P}).do_prepare: $(TARGET_${P}).do_depends \
| $(if $(${P}_SPEC_PATCH),${SDIR}/$(${P}_SPEC_PATCH)) $(if $(${P}_PATCHES),$(addprefix ${SDIR}/,$(${P}_PATCHES)))

]]function

function[[ rpm_do_prepare

$(TARGET_${P}).do_prepare: $(${P}_SRCRPM)
	$(rpm_src_install) $(${P}_SRCRPM)
	$(if $(${P}_SPEC_PATCH), cd $(specsprefix) && patch -p1 $(${P}_SPEC) < ${SDIR}/$(${P}_SPEC_PATCH) )
	$(if $(${P}_PATCHES), cp $(addprefix ${SDIR}/,$(${P}_PATCHES)) $(sourcesprefix) )
	touch $@

]]function

#FIXME:
function[[ rpm_do_compile

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	@echo "==> Building ${P} ..."
	$(rpm_build) $(specsprefix)/$(${P}_SPEC)
	touch $@
]]function

function[[ rpm_do_package

DO_PACKAGE_${P} ?=

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
ifeq (${SYSROOT},target)
	mv $(PKDIR)/$(targetprefix)/* $(PKDIR)
	rmdir --ignore-fail-on-non-empty --parent $(PKDIR)/$(targetprefix)/
endif
	$(DO_PACKAGE_${P})
	touch $@

]]function

function[[ rpm
call[[ rpm_do_prepare ]]
call[[ rpm_do_compile ]]
call[[ rpm_do_package ]]
]]function
