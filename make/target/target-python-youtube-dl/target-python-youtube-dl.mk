#
# AR-P buildsystem smart Makefile
#
package[[ target_python_youtube_dl

BDEPENDS_${P} = $(target_python_setuptools)

PV_${P} = git
PR_${P} = 1
PACKAGE_ARCH_${P} = all

call[[ base ]]

rule[[
  git://github.com/rg3/youtube-dl.git
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
	sed -i '1 c\#!/\usr/\bin/\env python' $(PKDIR)/usr/bin/youtube-dl
	touch $@


DESCRIPTION_${P} = "Small command-line program to download videos from YouTube.com and other video sites"
RDEPENDS_${P} = python_core python_unixadmin python_html python_ctypes python_email
FILES_${P} =   \
$(PYTHON_DIR)/site-packages/youtube_dl/* \
/usr/bin/youtube-dl

call[[ ipkbox ]]

]]package
