#
# AR-P buildsystem smart Makefile
#
package[[ target_libstb_hal

BDEPENDS_${P} = $(target_glibc) $(target_ffmpeg) $(target_libalsa) $(target_libpng) $(target_libass) $(target_libopenthreads)

PV_${P} = git
PR_${P} = 2

ifdef CONFIG_GSTREAMER
BDEPENDS_${P} += $(target_gstreamer)
CONFIG_FLAGS_${P} += --enable-gstreamer
endif

call[[ base ]]

rule[[

ifdef CONFIG_NEUTRINO_SRC_MASTER
  git://github.com/OpenAR-P/libstb-hal-cst-next.git;b=master
endif

ifdef CONFIG_NEUTRINO_SRC_MAX
  git://github.com/Duckbox-Developers/libstb-hal-cst-next.git;b=master
endif

]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./autogen.sh && \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix=/usr \
			--with-libdir=/usr/lib \
			--with-themesdir=/usr/share/tuxbox/neutrino/themes \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			--with-target=cdk \
			--with-boxtype=$(TARGET) \
			$(PLATFORM_CPPFLAGS) \
			CFLAGS="$(CXXFLAGS_target_neutrino)" \
			CPPFLAGS="$(CPPFLAGS_target_neutrino)" \
		&& \
		$(run_make)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} =  libstb-hal
RDEPENDS_${P} = ffmpeg libpng16 libasound2
FILES_${P} = /usr/lib/* /usr/bin/spark_fp

call[[ ipkbox ]]

]]package

