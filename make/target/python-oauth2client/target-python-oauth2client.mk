#
# AR-P buildsystem smart Makefile
#
package[[ target_python_oauth2client

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = git
PR_${P} = 1
PACKAGE_ARCH_${P} = all

call[[ base ]]

rule[[
  git://github.com/google/oauth2client.git
  patch:file://${PN}.patch
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && $(python_build)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(python_install)
	touch $@


DESCRIPTION_${P} = "A client library for accessing resources protected by OAuth 2.0"
RDEPENDS_${P} = python_core
FILES_${P} = $(PYTHON_DIR)/site-packages/oauth2client/*

call[[ ipkbox ]]

]]package
