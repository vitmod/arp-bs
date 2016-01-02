#
# AR-P buildsystem smart Makefile
#
package[[ target_python_uritemplate

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 0.6
PR_${P} = 1
PACKAGE_ARCH_${P} = all
DIR_${P} = $(WORK_${P})/uritemplate-${PV}

call[[ base ]]

rule[[
  extract:https://pypi.python.org/packages/source/u/uritemplate/uritemplate-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && $(python_build)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(python_install)
	touch $@


DESCRIPTION_${P} = "URI Templates"
RDEPENDS_${P} = python_core
FILES_${P} = $(PYTHON_DIR)/site-packages/uritemplate/*

call[[ ipkbox ]]

]]package
