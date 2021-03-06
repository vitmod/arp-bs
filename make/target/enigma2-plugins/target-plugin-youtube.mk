#
# AR-P buildsystem smart Makefile
#
package[[ target_plugin_youtube

BDEPENDS_${P} = $(target_filesystem) $(cross_python)

PV_${P} = git
PR_${P} = 1
PACKAGE_ARCH_${P} = all

call[[ base ]]

rule[[
  git://github.com/Taapat/enigma2-plugin-youtube.git:b=master
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

NAME_${P} = enigma2-plugin-extensions-youtube
DESCRIPTION_${P} = Watch YouTube videos
MAINTAINER_${P} = Taapat taapat@gmail.com
RDEPENDS_${P} = python_core python_codecs python_json python_netclient python_zlib python-twisted-web

FILES_${P} = /usr/lib/enigma2/python/Plugins/Extensions/YouTube/*

call[[ ipkbox ]]

]]package
