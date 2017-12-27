#
# AR-P buildsystem smart Makefile
#
package[[ target_libpng

BDEPENDS_${P} = $(target_glibc) $(target_zlib)

PV_${P} = 1.6.34
PR_${P} = 2

call[[ base ]]

rule[[
#  extract:https://sourceforge.net/projects/libpng/files/libpng16/${PV}/${PN}-${PV}.tar.xz
  extract:https://download.sourceforge.net/${PN}/${PN}-${PV}.tar.xz
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
