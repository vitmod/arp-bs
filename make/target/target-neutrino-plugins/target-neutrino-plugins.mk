#
# NEUTRINO
#
ifeq ($(strip $(CONFIG_BUILD_NEUTRINO)),y)
package[[ target_neutrino_plugins

BDEPENDS_${P} =  $(target_lua) $(target_neutrino)
PV_${P} = git
PR_${P} = 1

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
  git://github.com/Duckbox-Developers/neutrino-mp-plugins.git;b=master
  patch:file://giflib.patch
  patch:file://font.patch
  patch:file://hl101.patch
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

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

	touch $@

call[[ ipk ]]

# Packaging
##########################################################################################
DESCRIPTION_${P} = Neutrino plugins and games
PACKAGES_${P} = \
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
	neutrino_plugins_yahtzee

FILES_neutrino_plugins_tuxcom = /var/tuxbox/plugins/tuxcom.cfg /var/tuxbox/plugins/tuxcom.so
FILES_neutrino_plugins_tuxwetter = /var/tuxbox/plugins/tuxwetter.so /var/tuxbox/plugins/tuxwetter.cfg /var/tuxbox/config/tuxwetter
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
RDEPENDS_eutrino_plugins_tetris = neutrino-plugins-libfx2
FILES_neutrino_plugins_vierg = /var/tuxbox/plugins/vierg.*
RDEPENDS_neutrino_plugins_vierg = neutrino-plugins-libfx2
FILES_neutrino_plugins_yahtzee = /var/tuxbox/plugins/yahtzee.*
RDEPENDS_neutrino_plugins_yahtzee = neutrino-plugins-libfx2

call[[ ipkbox ]]

]]package
endif

