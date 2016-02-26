#
# AR-P buildsystem smart Makefile
#
package[[ target_python_six

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 1.9.0
PR_${P} = 1
PACKAGE_ARCH_${P} = all
DIR_${P} = $(WORK_${P})/six-${PV}

call[[ base ]]

rule[[
  extract:https://pypi.python.org/packages/source/s/six/six-${PV}.tar.gz
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && $(python_build)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(python_install)
	touch $@


DESCRIPTION_${P} = "Python 2 and 3 compatibility library"
RDEPENDS_${P} = python_core
FILES_${P} = $(PYTHON_DIR)/site-packages/six.p*

call[[ ipkbox ]]

]]package
