#
# AR-P buildsystem smart Makefile
#
package[[ target_libfribidi

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 0.19.7
PR_${P} = 2

PN_${P} = fribidi

call[[ base ]]

rule[[
  extract:http://fribidi.org/download/${PN}-${PV}.tar.bz2
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-memopt \
			--with-glib=no \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

PACKAGES_${P} = libfribidi0 libfribidi_bin
DESCRIPTION_${P} = Fribidi library for bidirectional text

RDEPENDS_libfribidi0 = libc6
FILES_libfribidi0 = /usr/lib/*.so.*

RDEPENDS_libfribidi_bin = libfribidi0 libc6
FILES_libfribidi_bin = /usr/bin/*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
