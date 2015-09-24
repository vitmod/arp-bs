#
# AR-P buildsystem smart Makefile
#
package[[ target_libdvdnav

BDEPENDS_${P} = $(target_glibc) $(target_libdvdread)

PV_${P} = 4.2.1
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://dvdnav.mplayerhq.hu/releases/${PN}-${PV}.tar.xz
  patch:file://${PN}_${PV}.patch
]]rule


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-static \
			--enable-shared \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	
	#$(call rewrite_config, $(PKDIR)/usr/bin/dvdnav-config)
	touch $@

call[[ ipk ]]

PACKAGES_${P} = libdvdnav4 libdvdnavmini4
DESCRIPTION_${P} = DVD navigation multimeda library - Development files  DVD navigation \
 multimeda library.  This package contains symbolic links,   header files, \
 and related items necessary for software development.
RDEPENDS_libdvdnav4 = libdvdread4 libc6
FILES_libdvdnav4 = /usr/lib/libdvdnav.so.*
RDEPENDS_libdvdnavmini4 = libc6
FILES_libdvdnavmini4 = /usr/lib/libdvdnavmini.so.*

call[[ ipkbox ]]

]]package
