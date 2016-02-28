#
# AR-P buildsystem smart Makefile
#
package[[ target_libvorbis

BDEPENDS_${P} = $(target_glibc) $(target_libogg)

PV_${P} = 1.3.4
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://downloads.xiph.org/releases/vorbis/${PN}-${PV}.tar.xz
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
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = The libvorbis reference implementation provides both a standard encoder and decoder
RDEPENDS_${P} = libogg0 libc6
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/*.so.*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
