#
# AR-P buildsystem smart Makefile
#
package[[ target_libdreamdvd

BDEPENDS_${P} = $(target_glibc) $(target_libdvdread) $(target_libdvdnav) $(target_libdvdcss)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  nothing:git://github.com/mirakels/libdreamdvd.git:r=6aa22dd3f530ca4be49946e07e4a0bfe60427bdf
  patch:file://libdreamdvd-1.0-support_sh4.patch
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		./configure \
			--build=$(build) \
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

NAME_${P} = libdreamdvd0
DESCRIPTION_${P} = libdvdnav wrapper for enigma2 based stbs.
RDEPENDS_${P} = libdvdcss2 libdvdread4 libdvdnav4 libc6
FILES_${P} = /usr/lib/libdreamdvd.so.*
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
