#
# AR-P buildsystem smart Makefile
#
package[[ target_expat

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 2.1.1
PR_${P} = 1

DESCRIPTION_${P} = Expat is an XML parser library written in C. It is a stream-oriented parser \
in which an application registers handlers for things the parser might find in the XML document

call[[ base ]]

rule[[
  extract:http://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${PN}-${PV}.tar.bz2
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

PACKAGES_${P} = libexpat1 libexpat_bin

RDEPENDS_libexpat1 = libc6
define postinst_libexpat1
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_libexpat1 = /usr/lib/libexpat.so.*

RDEPENDS_libexpat_bin = libexpat1 libc6
FILES_libexpat_bin = /usr/bin/xmlwf

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
