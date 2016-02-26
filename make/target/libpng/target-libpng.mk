#
# AR-P buildsystem smart Makefile
#
package[[ target_libpng

BDEPENDS_${P} = $(target_glibc) $(target_zlib)

PV_${P} = 1.6.21
PR_${P} = 2

call[[ base ]]

rule[[
  extract:http://sourceforge.net/projects/libpng/files/latest/${PN}-${PV}.tar.xz
  nothing:file://${PN}.diff
  patch:file://${PN}-workaround_for_stmfb_alpha_error.patch
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-maintainer-mode \
			--prefix=/usr \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	$(call rewrite_config, $(PKDIR)/usr/bin/libpng-config)
	touch $@

call[[ ipk ]]

PACKAGES_${P} = libpng16
DESCRIPTION_libpng16 = libpng
RDEPENDS_libpng16 = libz1 libc6
FILES_libpng16 = /usr/lib/*.so.*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
