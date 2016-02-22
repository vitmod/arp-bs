#
# XBMC
#
ifeq ($(strip $(CONFIG_BUILD_XBMC)),y)
package[[ target_xbmc

BDEPENDS_${P} = $(target_boost) $(target_libass) $(target_libmpeg2) $(target_python) $(target_python_twisted) $(target_libmodplug) $(target_taglib) $(target_libnfs) $(target_libmicrohttpd) $(target_expat) $(target_libxmlccwrap) $(target_tinyxml) $(target_libsamplerate) $(target_flac) $(target_jasper) $(target_gst_plugins_dvbmediasink) $(target_libjpeg_turbo) $(target_lzo) $(target_fontconfig) $(target_curl) $(target_util_linux) $(target_libalsa) $(target_libsigc) $(target_libdvbsipp) $(target_libgif) $(target_libmme_host) $(target_libmmeimage) $(target_libstgles) $(target_yajl) $(target_pcre) $(target_libcdio)

PV_${P} = git
PR_${P} = 1
PACKAGE_ARCH_${P} = $(box_arch)

DESCRIPTION_${P} = Framebuffer-based digital media application


CONFIG_FLAGS_${P} = \
			SWIG_EXE=none \
			JRE_EXE=none \
			--disable-gl \
			--enable-glesv1 \
			--disable-gles \
			--enable-webserver \
			--enable-nfs \
			--disable-x11 \
			--disable-samba \
			--disable-mysql \
			--disable-joystick \
			--disable-rsxs \
			--disable-projectm \
			--disable-goom \
			--disable-afpclient \
			--disable-airplay \
			--disable-airtunes \
			--disable-dvdcss \
			--disable-hal \
			--disable-avahi \
			--disable-optical-drive \
			--disable-libbluray \
			--disable-texturepacker \
			--disable-libcec \
			--disable-sdl \
			--enable-gstreamer \
			--disable-paplayer \
			--enable-gstplayer \
			--enable-dvdplayer \
			--disable-pulse \
			--disable-alsa \
			--disable-ssh \
			use_texturepacker_native=yes \
			USE_TEXTUREPACKER_NATIVE_ROOT=-I$(targetprefix)/usr \
			PYTHON_CPPFLAGS=-I$(targetprefix)/usr/include/python$(PYTHON_VERSION) \
			PY_PATH=$(targetprefix)/usr \

GST_BASE_RDEPS = \
	gst_plugins_base_alsa \
	gst_plugins_base_app \
	gst_plugins_base_audioconvert \
	gst_plugins_base_audioresample \
	gst_plugins_base_decodebin \
	gst_plugins_base_decodebin2 \
	gst_plugins_base_ogg \
	gst_plugins_base_playbin \
	gst_plugins_base_subparse \
	gst_plugins_base_typefindfunctions \
	gst_plugins_base_vorbis

GST_GOOD_RDEPS = \
	gst_plugins_good_apetag \
	gst_plugins_good_audioparsers \
	gst_plugins_good_autodetect \
	gst_plugins_good_avi \
	gst_plugins_good_flac \
	gst_plugins_good_flv \
	gst_plugins_good_icydemux \
	gst_plugins_good_id3demux \
	gst_plugins_good_isomp4 \
	gst_plugins_good_matroska \
	gst_plugins_good_rtp \
	gst_plugins_good_rtpmanager \
	gst_plugins_good_rtsp \
	gst_plugins_good_souphttpsrc \
	gst_plugins_good_udp \
	gst_plugins_good_wavparse

GST_BAD_RDEPS = \
	gst_plugins_bad_cdxaparse \
	gst_plugins_bad_mms \
	gst_plugins_bad_mpegdemux \
	gst_plugins_bad_rtmp \
	gst_plugins_bad_vcdsrc \
	gst_plugins_bad_fragmented \
	gst_plugins_bad_faad

GST_UGLY_RDEPS = \
	gst_plugins_ugly_asf \
	gst_plugins_ugly_cdio \
	gst_plugins_ugly_dvdsub \
	gst_plugins_ugly_mad \
	gst_plugins_ugly_mpegaudioparse \
	gst_plugins_ugly_mpegstream

PYTHON_RDEPS = \
	libpython2.7 \
	python-threading \
	python-core \
	python-twisted-core \
	python-fcntl \
	python-netclient \
	python-netserver \
	python-math \
	python-codecs \
	python-pickle \
	python-twisted-web \
	python-zlib \
	python-crypt \
	python-lang \
	python-subprocess \
	python-zopeinterface \
	python-xml \
	python-compression \
	python-shell \
	python-re

ifdef CONFIG_SPARK
CPPFLAGS_${P} += -I$(driverdir)/frontcontroller/aotom
endif

ifdef CONFIG_SPARK7162
CPPFLAGS_${P} += -I$(driverdir)/frontcontroller/aotom
endif

call[[ base ]]

rule[[

ifdef CONFIG_XBMC
  git://github.com/xbmc/xbmc.git:r=12.2-Frodo
  patch:file://xbmc-nightly.0.diff
  patch:file://xbmc-texture.patch
endif

]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./bootstrap && \
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
	$(run_make) -C $(DIR_${P}) install DESTDIR=$(PKDIR)
	if [ -e $(PKDIR)/usr/lib/xbmc/xbmc.bin ]; then \
		$(target)-strip $(PKDIR)/usr/lib/xbmc/xbmc.bin; \
	fi

	touch $@

call[[ ipk ]]

# Packaging
##########################################################################################

PACKAGES_${P} = xbmc_core xbmc_addons xbmc_language
DESCRIPTION_${P} = xbmc
SRC_URI_${P} = git://github.com/xbmc/xbmc.git

RDEPENDS_xbmc_core = libstgles libmad0 libsamplerate0 libogg0 libvorbis libmodplug curl libjpeg-turbo libflac8 libbz2 libtiff5 liblzo2 libz1 libfontconfig1 libfribidi0 libfreetype6 jasper libsqlite3 libpng16 libpcre libcdio12 \
yajl libmicrohttpd tinyxml $(PYTHON_RDEPS) $(GST_BASE_RDEPS) $(GST_GOOD_RDEPS) $(GST_BAD_RDEPS) $(GST_UGLY_RDEPS) gst_plugins_dvbmediasink gst_plugins_fluendo_mpegdemux gst_plugin_subsink libexpat1 lirc libnfs taglib directfb

FILES_xbmc_core = /usr/bin/xbmc \
		/usr/lib/xbmc/* \
		/usr/share/icons/* \
		/usr/share/xbmc/media/* \
		/usr/share/xbmc/sounds/* \
		/usr/share/xbmc/system/* \
		/usr/share/xbmc/userdata/* \
		/usr/share/xbmc/FEH.py

DESCRIPTION_xbmc_addons = xbmc addons
FILES_xbmc_addons = \
		/usr/share/xbmc/addons/library.xbmc.gui/* \
		/usr/share/xbmc/addons/library.xbmc.pvr/* \
		/usr/share/xbmc/addons/library.xbmc.addon/* \
		/usr/share/xbmc/addons/repository.xbmc.org/* \
		/usr/share/xbmc/addons/xbmc.metadata/* \
		/usr/share/xbmc/addons/xbmc.addon/* \
		/usr/share/xbmc/addons/xbmc.core/* \
		/usr/share/xbmc/addons/xbmc.gui/* \
		/usr/share/xbmc/addons/xbmc.json/* \
		/usr/share/xbmc/addons/xbmc.pvr/* \
		/usr/share/xbmc/addons/webinterface.default/* \
		/usr/share/xbmc/addons/skin.confluence/*

DESCRIPTION_xbmc_language = xbmc language files
FILES_xbmc_language = \
		/usr/share/xbmc/language/Russian/* \
		/usr/share/xbmc/language/English/* \
		/usr/share/xbmc/language/German/*

call[[ ipkbox ]]

]]package
endif
