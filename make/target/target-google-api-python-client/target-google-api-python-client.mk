#
# AR-P buildsystem smart Makefile
#
package[[ target_google_api_python_client

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = git
PR_${P} = 2
PACKAGE_ARCH_${P} = all

call[[ base ]]

rule[[
  git://github.com/google/${PN}.git
]]rule

call[[ git ]]

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


DESCRIPTION_${P} = "Python client library for Google's discovery based APIs."
RDEPENDS_${P} = python_core python_misc python_six python_oauth2client python_httplib2 python_uritemplate
FILES_${P} =   \
$(PYTHON_DIR)/site-packages/apiclient/* \
$(PYTHON_DIR)/site-packages/googleapiclient/*

call[[ ipkbox ]]

]]package
