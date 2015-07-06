#
# AR-P buildsystem smart Makefile
#
package[[ target_plugin_youtube

PV_${P} = git
PR_${P} = 1
PACKAGE_ARCH_${P} = all

call[[ base ]]

rule[[
  git://github.com/Taapat/enigma2-plugin-youtube.git:b=master
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
	$(crossprefix)/bin/python ./setup.py build
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
	$(crossprefix)/bin/python ./setup.py install --install-purelib=$(PKDIR)/usr/lib/enigma2/python/Plugins
	touch $@

NAME_${P} = enigma2-plugin-extensions-youtube
DESCRIPTION_${P} = Watch YouTube videos
RDEPENDS_${P} = python_core python-twisted-web google-api-python-client python-youtube-dl

FILES_${P} = /usr/lib/enigma2/python/Plugins/Extensions/YouTube/*

call[[ ipkbox ]]

]]package
