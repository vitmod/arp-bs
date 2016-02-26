#
# AR-P buildsystem smart Makefile
#
package[[ target_lzo

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 2.09
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://www.oberhumer.com/opensource/${PN}/download/${PN}-${PV}.tar.gz
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--enable-shared \
			--prefix=/usr \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = liblzo2
DESCRIPTION_${P} = Lossless data compression library
RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/liblzo2.so.*

define postinst_${P}
#!/bin/sh
if [ x"$$D" = "x" ]; then
	if [ -x /sbin/ldconfig ]; then /sbin/ldconfig ; fi
fi
endef

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
