#
# AR-P buildsystem smart Makefile
#
package[[ target_python_gdata

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = 2.0.18
PR_${P} = 2

DIR_${P} = $(WORK_${P})/gdata-${PV}

call[[ base ]]

rule[[
  extract:http://gdata-python-client.googlecode.com/files/gdata-${PV}.tar.gz
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


DESCRIPTION_${P} = "The Google Data APIs (Google Data) provide a simple protocol for reading and writing data on the web. \
Though it is possible to use these services with a simple HTTP client, this library provides helpful tools to streamline \
your code and keep up with server-side changes. "
RDEPENDS_${P} = python-json
FILES_${P} =   \
$(PYTHON_DIR)/site-packages/atom/*.p* \
$(PYTHON_DIR)/site-packages/gdata/*.p* \
$(PYTHON_DIR)/site-packages/gdata/youtube/*.p* \
$(PYTHON_DIR)/site-packages/gdata/geo/*.p* \
$(PYTHON_DIR)/site-packages/gdata/media/*.p* \
$(PYTHON_DIR)/site-packages/gdata/oauth/*.p* \
$(PYTHON_DIR)/site-packages/gdata/tlslite/*.p* \
$(PYTHON_DIR)/site-packages/gdata/tlslite/integration/*.p* \
$(PYTHON_DIR)/site-packages/gdata/tlslite/utils/*.p*

call[[ ipkbox ]]

]]package
