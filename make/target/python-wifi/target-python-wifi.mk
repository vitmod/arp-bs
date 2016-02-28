#
# AR-P buildsystem smart Makefile
#
package[[ target_python_wifi

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 0.6.1
PR_${P} = 1

call[[ base ]]

rule[[
  extract:https://pypi.python.org/packages/source/p/python-wifi/${PN}-${PV}.tar.bz2
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && $(python_build)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(python_install)
	touch $@

call[[ ipk ]]


DESCRIPTION_${P} = Python WiFi is a Python module that provides read and write access \
	to a wireless network card's capabilities using the Linux Wireless Extensions
RDEPENDS_${P} = python_core python_ctypes python_datetime
FILES_${P} = $(PYTHON_DIR)/site-packages/pythonwifi

call[[ ipkbox ]]

]]package
