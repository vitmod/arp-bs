#
# AR-P buildsystem smart Makefile
#
package[[ target_libtuxtxt

BDEPENDS_${P} = $(target_freetype) $(target_zlib) $(target_driver_headers)

PV_${P} = git
PR_${P} = 2

call[[ base ]]

rule[[
  nothing:git://github.com/OpenPLi/tuxtxt.git:sub=libtuxtxt
  patch:file://${PN}.diff
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
	touch $@

call[[ ipk ]]

NAME_${P} = libtuxtxt0
DESCRIPTION_${P} = tuxbox libtuxtxt
RDEPENDS_${P} = libfreetype6 libz1
FILES_${P} = /usr/lib/libtuxtxt*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
