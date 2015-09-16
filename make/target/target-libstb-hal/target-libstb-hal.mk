#
# AR-P buildsystem smart Makefile
#
ifeq ($(strip $(CONFIG_BUILD_NEUTRINO)),y)

package[[ target_libstb_hal

BDEPENDS_${P} = $(target_glibc) $(target_ffmpeg) $(target_libalsa) $(target_libpng) $(target_libass) $(target_libopenthreads)

PV_${P} = git
PR_${P} = 1

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

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./autogen.sh && \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix=/usr \
			--enable-shared \
			--with-target=cdk \
			--with-boxtype=$(TARGET) \
			$(PLATFORM_CPPFLAGS) \
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

endif
