#
# AR-P buildsystem smart Makefile
#
package[[ target_enigma2_skins_metropolishd

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = git
PR_${P} = 2
PACKAGE_ARCH_${P} = all

call[[ base ]]

rule[[
  git://github.com/Taapat/skin-MetropolisHD
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && cp -dpR $(DIR_${P})/usr  $(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = enigma2-plugin-skin-metropolishd
DESCRIPTION_${P} = Skin MetropolisHD for enigma2
RDEPENDS_${P} = enigma2 font_lcd
FILES_${P} = /usr

call[[ ipkbox ]]

]]package
