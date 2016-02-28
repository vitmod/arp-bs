#
# AR-P buildsystem smart Makefile
#
package[[ target_libmicrohttpd

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 0.9.48
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://ftp.halifax.rwth-aachen.de/gnu/${PN}/${PN}-${PV}.tar.gz
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
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR) && \
	rm -f $(PKDIR)/usr/share/info/dir
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = library for embedding an HTTP(S) server into C applications
RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/*.so.*
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
