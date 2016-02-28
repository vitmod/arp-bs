#
# AR-P buildsystem smart Makefile
#
package[[ target_libvorbisidec

BDEPENDS_${P} = $(target_glibc) $(target_libogg)

PV_${P} = 1.0.2+svn18153
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://ftp.debian.org/debian/pool/main/libv/${PN}/${PN}_${PV}.orig.tar.gz
  patch:file://tremor.diff
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		ACLOCAL_FLAGS="-I . -I $(targetprefix)/usr/share/aclocal" \
		$(BUILDENV) \
		./autogen.sh \
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

NAME_${P} = libvorbisidec1
DESCRIPTION_${P} = Fixed-point decoder - Development files tremor is a fixed point implementation of the vorbis codec.  This package contains static libraries for software development.
RDEPENDS_${P} = libogg0 libc6
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/*.so.*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
