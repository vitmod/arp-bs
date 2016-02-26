#
# AR-P buildsystem smart Makefile
#
package[[ target_python_httplib2

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 0.9.1
PR_${P} = 1
PACKAGE_ARCH_${P} = all
DIR_${P} = $(WORK_${P})/httplib2-${PV}

call[[ base ]]

rule[[
  extract:https://pypi.python.org/packages/source/h/httplib2/httplib2-${PV}.tar.gz
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && $(python_build)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(python_install)
	touch $@


DESCRIPTION_${P} = "A comprehensive HTTP client library"
RDEPENDS_${P} = python_core
FILES_${P} = $(PYTHON_DIR)/site-packages/httplib2/*

call[[ ipkbox ]]

]]package
