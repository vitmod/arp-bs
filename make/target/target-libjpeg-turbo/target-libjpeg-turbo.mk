#
# AR-P buildsystem smart Makefile
#
package[[ target_libjpeg_turbo

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 1.3.90
PR_${P} = 1

PN_${P} = libjpeg-turbo

call[[ base ]]

rule[[
  extract:http://sourceforge.net/projects/${PN}/files/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
		&& \
		$(MAKE) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(MAKE) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libjpeg-turbo
DESCRIPTION_${P} = libjpeg contains a library for handling the JPEG (JFIF) image format, as \
 well as related programs for accessing the libjpeg functions.
RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/*.so.* 

call[[ ipkbox ]]

]]package
