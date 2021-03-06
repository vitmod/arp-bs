#
# AR-P buildsystem smart Makefile
#
package[[ target_libarchive

BDEPENDS_${P} = $(target_glibc) $(target_libxml2)

PV_${P} = 3.1.2
PR_${P} = 1
PACKAGE_ARCH_${P} = $(box_arch)

call[[ base ]]

rule[[
  extract:http://www.libarchive.org/downloads/${PN}-${PV}.tar.gz
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
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = ${PN}
DESCRIPTION_${P} = Multi-format archive and compression library
FILES_${P} = /usr/lib/*.so*

call[[ ipkbox ]]

]]package
