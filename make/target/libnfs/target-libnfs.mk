#
# AR-P buildsystem smart Makefile
#
package[[ target_libnfs

BDEPENDS_${P} = $(target_glibc)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  nothing:git://github.com/sahlberg/libnfs.git:r=c0ebf57b212ffefe83e2a50358499f68e7289e93
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
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

DESCRIPTION_${P} = LIBNFS is a client library for accessing NFS shares over a network.

RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/*.so.*
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
