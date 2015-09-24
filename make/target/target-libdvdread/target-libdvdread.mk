#
# AR-P buildsystem smart Makefile
#
package[[ target_libdvdread

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 4.9.9
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
	
	#$(call rewrite_config, $(PKDIR)/usr/bin/dvdread-config)
	touch $@

call[[ ipk ]]

NAME_${P} = libdvdread4
DESCRIPTION_${P} = DVD navigation multimeda library - Development files  DVD navigation \
 multimeda library.  This package contains symbolic links,   header files, \
 and related items necessary for software development.
RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/*.so.*

call[[ ipkbox ]]

]]package
