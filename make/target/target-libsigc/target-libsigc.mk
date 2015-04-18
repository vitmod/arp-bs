#
# AR-P buildsystem smart Makefile
#
package[[ target_libsigc

BDEPENDS_${P} = $(target_gcc_lib)

ifdef CONFIG_BUILD_NEUTRINO
PV_${P} = 2.3.2
PR_${P} = 1
DV_${P} = 2.3
else
PV_${P} = 1.2.7
PR_${P} = 1
DV_${P} = 1.2
endif


DIR_${P} = $(WORK_${P})/libsigc++-${PV}

call[[ base ]]

rule[[
ifdef CONFIG_BUILD_NEUTRINO
  extract:http://ftp.gnome.org/pub/GNOME/sources/libsigc++/${DV}/libsigc++-${PV}.tar.xz
else
  extract:http://ftp.gnome.org/pub/GNOME/sources/libsigc++/${DV}/libsigc++-${PV}.tar.gz
endif
]]rule


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-checks \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libsigc-${DV}
DESCRIPTION_${P} =  A library for loose coupling of C++ method calls
RDEPENDS_${P} = libstdc++6 libgcc1
FILES_${P} = /usr/lib/*.so.*

call[[ ipkbox ]]

]]package
