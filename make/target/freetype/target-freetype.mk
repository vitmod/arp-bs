#
# AR-P buildsystem smart Makefile
#
package[[ target_freetype

BDEPENDS_${P} = $(target_glibc) $(target_libpng) $(target_zlib)

PV_${P} = 2.6.2
PR_${P} = 2

DESCRIPTION_${P} = Freetype font rendering library \
 FreeType is a software font engine that is designed to be small, \
 efficient, highly customizable, and portable while capable of producing \
 high-quality output (glyph images). It can be used in graphics libraries, \
 display servers, font conversion tools, text image generation tools, and \
 many other products as well.

call[[ base ]]

rule[[
  extract:http://download.savannah.gnu.org/releases/${PN}/${PN}-${PV}.tar.bz2
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
		&& \
		$(run_make)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)

	$(call rewrite_config, $(PKDIR)/usr/bin/freetype-config)
	touch $@

call[[ ipk ]]

NAME_${P} = libfreetype6
RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/*.so.*

call[[ ipkbox ]]

]]package
