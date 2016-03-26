#
# NEUTRINO
#
ifeq ($(strip $(CONFIG_BUILD_NEUTRINO)),y)
package[[ target_neutrino_plugins

BDEPENDS_${P} =  $(target_lua) $(target_neutrino)
PV_${P} = git
PR_${P} = 4

DESCRIPTION_${P} = Framebuffer-based digital media application

CPPFLAGS_${P} += "-DMARTII -DNEW_LIBCURL"

CONFIG_FLAGS_${P} = \
		--with-boxtype=$(TARGET) \
		--enable-giflib \
		--with-target=cdk \
		--oldinclude=$(targetprefix)/include \
		--enable-maintainer-mode \
		--with-libdir=/usr/lib \
		--with-datadir=/usr/share/tuxbox \
		--with-fontdir=/usr/share/fonts \
		--with-configdir=/var/tuxbox/config \
		--with-gamesdir=/var/tuxbox/games \
		--with-plugindir=/var/tuxbox/plugins \
		LDFLAGS="$(TARGET_LDFLAGS) -L$(workprefix)/target_neutrino_plugins/neutrino-plugins-git/fx2/lib/.libs" \
		$(PLATFORM_CPPFLAGS) \
		CPPFLAGS=$(CPPFLAGS_${P})

call[[ base ]]

rule[[
  git://github.com/OpenAR-P/neutrino-mp-plugins.git;b=master
  nothing:file://cam
  nothing:file://camstartstop
  nothing:file://flex_cammanager.conf
  nothing:file://flex_tuxcom.conf
  nothing:file://flex_tuxwetter.conf
  nothing:file://camd3_load_*
  nothing:file://cccam_load_*
  nothing:file://flex_loadenigma.conf
  nothing:file://flex_tuner.conf
  nothing:file://mgcamd_load_*
  nothing:file://oscam_load_*
  nothing:file://wicardd_load_*
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./autogen.sh && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			$(CONFIG_FLAGS_${P}) \
			CFLAGS="$(CXXFLAGS_target_neutrino)" \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	$(run_make) -C $(DIR_${P}) install DESTDIR=$(PKDIR)
	$(INSTALL_DIR) $(PKDIR)/etc/init.d
	$(INSTALL_DIR) $(PKDIR)/var/tuxbox/config/flex
	$(INSTALL_DIR) $(PKDIR)/var/tuxbox/config/flex/camd3_load
	$(INSTALL_DIR) $(PKDIR)/var/tuxbox/config/flex/cccam_load
	$(INSTALL_DIR) $(PKDIR)/var/tuxbox/config/flex/mgcamd_load
	$(INSTALL_DIR) $(PKDIR)/var/tuxbox/config/flex/oscam_load
	$(INSTALL_DIR) $(PKDIR)/var/tuxbox/config/flex/wicardd_load
	$(INSTALL_BIN) $(DIR_${P})/cam $(PKDIR)/etc/init.d/cam
	$(INSTALL_BIN) $(DIR_${P})/camstartstop $(PKDIR)/var/tuxbox/plugins/camstartstop
	$(INSTALL_FILE) $(DIR_${P})/flex_cammanager.conf $(PKDIR)/var/tuxbox/config/flex/flex_cammanager.conf
	$(INSTALL_FILE) $(DIR_${P})/flex_loadenigma.conf $(PKDIR)/var/tuxbox/config/flex/flex_loadenigma.conf
	$(INSTALL_FILE) $(DIR_${P})/flex_tuner.conf $(PKDIR)/var/tuxbox/config/flex/flex_tuner.conf
	$(INSTALL_FILE) $(DIR_${P})/flex_tuxcom.conf $(PKDIR)/var/tuxbox/config/flex/flex_tuxcom.conf
	$(INSTALL_FILE) $(DIR_${P})/flex_tuxwetter.conf $(PKDIR)/var/tuxbox/config/flex/flex_tuxwetter.conf
	$(INSTALL_FILE) $(DIR_${P})/camd3_load_* $(PKDIR)/var/tuxbox/config/flex/camd3_load/
	$(INSTALL_FILE) $(DIR_${P})/cccam_load_* $(PKDIR)/var/tuxbox/config/flex/cccam_load/
	$(INSTALL_FILE) $(DIR_${P})/mgcamd_load_* $(PKDIR)/var/tuxbox/config/flex/mgcamd_load/
	$(INSTALL_FILE) $(DIR_${P})/oscam_load_* $(PKDIR)/var/tuxbox/config/flex/oscam_load/
	$(INSTALL_FILE) $(DIR_${P})/wicardd_load_* $(PKDIR)/var/tuxbox/config/flex/wicardd_load/

	touch $@

call[[ ipk ]]

# Packaging
##########################################################################################
DESCRIPTION_${P} = Neutrino plugins and games
PACKAGES_${P} = \
	neutrino_plugins_cammanager \
	neutrino_plugins_tuxcom \
	neutrino_plugins_tuxwetter \
	neutrino_plugins_msgbox \
	neutrino_plugins_getrc \
	neutrino_plugins_shellexec \
	neutrino_plugins_libfx2 \
	neutrino_plugins_lemmings \
	neutrino_plugins_master \
	neutrino_plugins_mines \
	neutrino_plugins_pacman \
	neutrino_plugins_snake \
	neutrino_plugins_soko \
	neutrino_plugins_sol \
	neutrino_plugins_solitair \
	neutrino_plugins_sudoku \
	neutrino_plugins_tank \
	neutrino_plugins_tetris \
	neutrino_plugins_vierg \
	neutrino_plugins_yahtzee \
	neutrino_camd3_load \
	neutrino_cccam_load \
	neutrino_mgcamd_load \
	neutrino_oscam_load \
	neutrino_wicardd_load \
	neutrino_enigma2_load \
	neutrino_tuner_load

FILES_neutrino_plugins_cammanager = /etc/init.d/cam /var/tuxbox/plugins/camstartstop /var/tuxbox/config/flex/flex_cammanager.conf
RDEPENDS_neutrino_plugins_cammanager = neutrino_plugins_shellexec neutrino_plugins_msgbox
FILES_neutrino_plugins_tuxcom = /var/tuxbox/plugins/tuxcom.cfg /var/tuxbox/plugins/tuxcom.so /var/tuxbox/config/flex/flex_tuxcom.conf
FILES_neutrino_plugins_tuxwetter = /var/tuxbox/plugins/tuxwetter.so /var/tuxbox/plugins/tuxwetter.cfg /var/tuxbox/config/tuxwetter /var/tuxbox/config/flex/flex_tuxwetter.conf
FILES_neutrino_plugins_msgbox = /bin/msgbox
FILES_neutrino_plugins_getrc = /bin/getrc
FILES_neutrino_plugins_shellexec = /bin/shellexec /var/tuxbox/config/shellexec.conf /var/tuxbox/plugins/shellexec.cfg /var/tuxbox/plugins/shellexec.so
# FX2 plugins sector
FILES_neutrino_plugins_libfx2 = /var/tuxbox/plugins/libfx2.so /var/tuxbox/plugins/games.cfg
FILES_neutrino_plugins_lemmings = /var/tuxbox/plugins/lemmings.*
RDEPENDS_neutrino_plugins_lemmings = neutrino-plugins-libfx2 
FILES_neutrino_plugins_master = /var/tuxbox/plugins/master.*
RDEPENDS_neutrino_plugins_master = neutrino-plugins-libfx2
FILES_neutrino_plugins_mines = /var/tuxbox/plugins/mines.*
RDEPENDS_neutrino_plugins_mines = neutrino-plugins-libfx2
FILES_neutrino_plugins_pacman = /var/tuxbox/plugins/pacman.*
RDEPENDS_neutrino_plugins_pacman = neutrino-plugins-libfx2
FILES_neutrino_plugins_snake = /var/tuxbox/plugins/snake.*
RDEPENDS_neutrino_plugins_snake = neutrino-plugins-libfx2
FILES_neutrino_plugins_soko = /var/tuxbox/plugins/soko.* /usr/share/tuxbox/sokoban/*
RDEPENDS_neutrino_plugins_soko = neutrino-plugins-libfx2
FILES_neutrino_plugins_sol = /var/tuxbox/plugins/sol.*
RDEPENDS_neutrino_plugins_sol = neutrino-plugins-libfx2
FILES_neutrino_plugins_solitair= /var/tuxbox/plugins/solitair.*
RDEPENDS_neutrino_plugins_solitair = neutrino-plugins-libfx2
FILES_neutrino_plugins_sudoku = /var/tuxbox/plugins/sudoku.*
RDEPENDS_neutrino_plugins_sudoku = neutrino-plugins-libfx2
FILES_neutrino_plugins_tank = /var/tuxbox/plugins/tank.*
RDEPENDS_neutrino_plugins_tank = neutrino-plugins-libfx2
FILES_neutrino_plugins_tetris = /var/tuxbox/plugins/tetris.*
RDEPENDS_neutrino_plugins_tetris = neutrino-plugins-libfx2
FILES_neutrino_plugins_vierg = /var/tuxbox/plugins/vierg.*
RDEPENDS_neutrino_plugins_vierg = neutrino-plugins-libfx2
FILES_neutrino_plugins_yahtzee = /var/tuxbox/plugins/yahtzee.*
RDEPENDS_neutrino_plugins_yahtzee = neutrino-plugins-libfx2
FILES_neutrino_camd3_load = /var/tuxbox/config/flex/camd3_load/camd3_load*
RDEPENDS_neutrino_camd3_load = neutrino_plugins_shellexec enigma2-plugin-softcams-camd3 neutrino_plugins_cammanager
FILES_neutrino_cccam_load = /var/tuxbox/config/flex/cccam_load/cccam_load*
RDEPENDS_neutrino_cccam_load = neutrino_plugins_shellexec enigma2-plugin-softcams-cccam neutrino_plugins_cammanager
FILES_neutrino_mgcamd_load = /var/tuxbox/config/flex/mgcamd_load/mgcamd_load*
RDEPENDS_neutrino_mgcamd_load = neutrino_plugins_shellexec enigma2-plugin-softcams-mgcamd neutrino_plugins_cammanager
FILES_neutrino_oscam_load = /var/tuxbox/config/flex/oscam_load/oscam_load*
RDEPENDS_neutrino_oscam_load = neutrino_plugins_shellexec enigma2-plugin-softcams-oscam neutrino_plugins_cammanager
FILES_neutrino_wicardd_load = /var/tuxbox/config/flex/wicardd_load/wicardd_load*
RDEPENDS_neutrino_wicardd_load = neutrino_plugins_shellexec enigma2-plugin-softcams-wicardd neutrino_plugins_cammanager
FILES_neutrino_enigma2_load = /var/tuxbox/config/flex/flex_loadenigma.conf
FILES_neutrino_tuner_load = /var/tuxbox/config/flex/flex_tuner.conf

call[[ ipkbox ]]

]]package
endif

