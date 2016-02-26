#
# AR-P buildsystem smart Makefile
#
package[[ target_libmodplug

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 0.8.8.5
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://sourceforge.net/projects/modplug-xmms/files/${PN}/${PV}/${PN}-${PV}.tar.gz
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--prefix=/usr \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} =  the library for decoding mod-like music formats

RDEPENDS_${P} = libc6
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/libmodplug.so.*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
