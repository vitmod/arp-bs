#
# AR-P buildsystem smart Makefile
#
package[[ target_tuxtxt32bpp

BDEPENDS_${P} = $(target_freetype) $(target_zlib) $(target_libtuxtxt)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://github.com/OpenPLi/tuxtxt.git:sub=tuxtxt
  patch:file://${PN}-1.0-fix_dbox_headers.diff
  install:-m644:-D:$(PKDIR)/etc/tuxtxt/tuxtxt2.conf:file://tuxtxt2.conf
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoheader && \
		autoconf && \
		libtoolize --force && \
		automake --foreign --add-missing && \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			--with-boxtype=generic \
			--with-configdir=/etc \
			--with-datadir=/usr/share/tuxtxt \
			--with-fontdir=/usr/share/fonts \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	cd $(DIR_${P}) && $(INSTALL_${P})

	rm -rf $(PKDIR)/usr/share/fonts/
	touch $@

call[[ ipk ]]

NAME_${P} = libtuxtxt32bpp0
DESCRIPTION_${P} = tuxbox tuxtxt for 32bit framebuffer
RDEPENDS_${P} = libtuxtxt0 libfreetype6 libz1
FILES_${P} = \
	/usr/lib/*.so.* \
	/usr/lib/enigma2/python/Plugins/Extensions/Tuxtxt/* \
	/etc/tuxtxt/tuxtxt2.conf

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
