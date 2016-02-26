#
# AR-P buildsystem smart Makefile
#
package[[ target_plugin_alternativesoftcammanager

PV_${P} = git
PR_${P} = 1
PACKAGE_ARCH_${P} = all

call[[ base ]]

rule[[
  git://github.com/Taapat/enigma2-plugin-alternativesoftcammanager.git:b=master
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
	$(crossprefix)/bin/python ./setup.py build
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
	$(crossprefix)/bin/python ./setup.py install \
	--install-purelib=$(PKDIR)/usr/lib/enigma2/python/Plugins
	touch $@

NAME_${P} = enigma2-plugin-extensions-alternativesoftcammanager
DESCRIPTION_${P} = Start, stop, restart SoftCams, change settings
MAINTAINER_${P} = Taapat taapat@gmail.com

FILES_${P} = /usr/lib/enigma2/python/Plugins/Extensions/AlternativeSoftCamManager/*

call[[ ipkbox ]]

]]package
