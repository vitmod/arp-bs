#
# NEUTRINO
#
ifeq ($(strip $(CONFIG_BUILD_NEUTRINO)),y)
package[[ target_neutrino

BDEPENDS_${P} =  $(target_libjpeg_turbo) $(target_libopenthreads) $(target_curl) $(target_util_linux) $(target_libalsa) $(target_libdvbsipp) $(target_libgif) $(target_libmme_host) $(target_libmmeimage) $(target_libsigc) $(target_lua) $(target_luaexpat) $(target_libstb_hal) $(target_aio_grab) $(target_tuxbox_configs)

PV_${P} = git
PR_${P} = 3
PACKAGE_ARCH_neutrino = $(box_arch)

DESCRIPTION_${P} = Framebuffer-based digital media application

ifdef CONFIG_DEBUG_ARP
CONFIG_FLAGS_${P} = \
		--with-debug
endif

CONFIG_FLAGS_${P} += \
		--enable-silent-rules \
		--enable-freesatepg \
		--with-boxtype=$(TARGET) \
		--enable-upnp \
		--enable-giflib \
		--with-tremor \
		--enable-ffmpegdec \
		--enable-lua \
		--with-libdir=/usr/lib \
		--with-datadir=/usr/share/tuxbox \
		--with-fontdir=/usr/share/fonts \
		--with-configdir=/var/tuxbox/config \
		--with-gamesdir=/var/tuxbox/games \
		--with-plugindir=/var/tuxbox/plugins \
		--with-iconsdir=/usr/share/tuxbox/neutrino/icons \
		--with-localedir=/usr/share/tuxbox/neutrino/locale \
		--with-private_httpddir=/usr/share/tuxbox/neutrino/httpd \
		--with-themesdir=/usr/share/tuxbox/neutrino/themes \
		--with-stb-hal-includes=$(DIR_target_libstb_hal)/include \
		--with-stb-hal-build=$(DIR_target_libstb_hal) \
		$(PLATFORM_CPPFLAGS) \
		CXXFLAGS="$(CXXFLAGS_${P})" \
		CPPFLAGS="$(CPPFLAGS_${P})"

CXXFLAGS_${P} += -Wall -W -Wshadow -g0 -pipe -Os -fno-strict-aliasing -D__KERNEL_STRICT_NAMES -DCPU_FREQ
CXXFLAGS_${P} += -D__STDC_CONSTANT_MACROS
CPPFLAGS_${P} += -I$(driverdir)/bpamem

ifeq ($(CONFIG_SPARK)$(CONFIG_SPARK7162),y)
CPPFLAGS_${P} += -I$(driverdir)/frontcontroller/aotom
endif

# media framework
ifdef CONFIG_GSTREAMER
BDEPENDS_${P} += $(target_gstreamer)
CONFIG_FLAGS_${P} += --enable-gstreamer
endif
ifdef CONFIG_EPLAYER3
BDEPENDS_${P} += $(target_libeplayer3) $(target_ffmpeg)
CONFIG_FLAGS_${P} += --enable-libeplayer3 LIBEPLAYER3_CPPFLAGS="-I$(appsdir)/misc/tools/libeplayer3/include"
RDEPENDS_${P} += libeplayer3
endif

# ???? lcd
ifdef CONFIG_EXTERNAL_LCD
BDEPENDS_${P} += $(target_graphlcd)
CONFIG_FLAGS_${P} += --enable-graphlcd
RDEPENDS_neutrino += libgraphlcd
endif

call[[ base ]]

rule[[

ifdef CONFIG_NEUTRINO_SRC_MASTER
  git://github.com/OpenAR-P/neutrino-mp-cst-next.git;b=master
  nothing:file://neutrino.sh
  nothing:file://post-wlan0.sh
  nothing:file://pre-wlan0.sh
endif

ifdef CONFIG_NEUTRINO_SRC_MAX
  git://github.com/Duckbox-Developers/neutrino-mp-cst-next.git;b=master
  patch:file://include.patch
  nothing:file://neutrino.sh
  nothing:file://post-wlan0.sh
  nothing:file://pre-wlan0.sh
endif

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
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	$(run_make) -C $(DIR_${P}) install DESTDIR=$(PKDIR) \

	$(target)-strip $(PKDIR)/usr/bin/neutrino
	$(target)-strip $(PKDIR)/usr/bin/pzapit
	$(target)-strip $(PKDIR)/usr/bin/sectionsdcontrol
	$(INSTALL_DIR) $(PKDIR)/etc
	$(INSTALL_DIR) $(PKDIR)/etc/network
	$(INSTALL_BIN) $(DIR_${P})/pre-wlan0.sh $(PKDIR)/etc/network/pre-wlan0.sh
	$(INSTALL_BIN) $(DIR_${P})/post-wlan0.sh $(PKDIR)/etc/network/post-wlan0.sh
	$(INSTALL_BIN) $(DIR_${P})/neutrino.sh $(PKDIR)/usr/bin/neutrino.sh
	echo "neutrino" > $(PKDIR)/etc/.gui
	rm -f $(PKDIR)/usr/share/fonts/md_khmurabi_10.ttf
	rm -f $(PKDIR)/usr/share/fonts/tuxtxt.ttf
	rm -f $(PKDIR)/usr/share/fonts/tuxtxt.otb

	touch $@

call[[ ipk ]]

# Packaging
##########################################################################################

PACKAGES_${P} = \
	neutrino \
	neutrino_plugins \
	neutrino_configs \
	font_dejavulgcsansmono_bold \
	font_micron \
	font_micron_bold \
	font_micron_italic \
	font_neutrino \
	font_pakenham


RDEPENDS_neutrino += neutrino-plugins neutrino-configs aio-grab liblua libssl1 libcrypto1 libcurl4 libid3tag0 libmad0 libvorbisidec1 libpng16 libjpeg-turbo libgif4 font-md-khmurabi font-tuxtxt font-dejavulgcsansmono-bold font-micron font-micron-bold font-micron-italic font-neutrino font-pakenham libfreetype6 ffmpeg libdvbsi++1 libopenthreads libusb_1.0 libasound2 libstb_hal libc6 libsigc-2.3 config-timezone

FILES_neutrino = /usr/bin/* /usr/sbin/* /etc/.gui /etc/network/*
FILES_neutrino_plugins = /usr/share/tuxbox /usr/share/iso-codes/*
FILES_neutrino_configs = /var

FILES_font_dejavulgcsansmono_bold = /usr/share/fonts/DejaVuLGCSansMono-Bold.ttf
DESCRIPTION_font_dejavulgcsansmono_bold = ttf fonts

FILES_font_micron = /usr/share/fonts/micron.ttf
DESCRIPTION_font_micron = ttf fonts

FILES_font_micron_bold = /usr/share/fonts/micron_bold.ttf
DESCRIPTION_font_micron_bold = ttf fonts

FILES_font_micron_italic = /usr/share/fonts/micron_italic.ttf
DESCRIPTION_font_micron_italic = ttf fonts

FILES_font_neutrino = /usr/share/fonts/neutrino.ttf
DESCRIPTION_ont_neutrino = ttf fonts

FILES_font_pakenham = /usr/share/fonts/pakenham.ttf
DESCRIPTION_font_pakenham = ttf fonts

call[[ ipkbox ]]

]]package
endif

