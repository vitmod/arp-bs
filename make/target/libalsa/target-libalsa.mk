#
# AR-P buildsystem smart Makefile
#
package[[ target_libalsa

BDEPENDS_${P} =

PV_${P} = 1.1.0
PR_${P} = 1

DIR_${P} = ${WORK}/alsa-lib-${PV}

call[[ base ]]

rule[[
  extract:ftp://ftp.alsa-project.org/pub/lib/alsa-lib-${PV}.tar.bz2
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_${P}) && \
		libtoolize --force --copy --automake && \
		aclocal -I $(hostprefix)/share/aclocal -I m4 && \
		autoheader && \
		automake --foreign --copy --add-missing && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--target=$(target) \
			--build=$(build) \
			--prefix=/usr \
			--with-debug=no \
			--enable-shared \
			--enable-static=no \
			--disable-python \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} =libasound2
DESCRIPTION_${P} = "ALSA library"
RDEPENDS_${P} = libc6
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/*.so.* /usr/share/alsa

call[[ ipkbox ]]

]]package
