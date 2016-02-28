#
# AR-P buildsystem smart Makefile
#
package[[ target_sdparm

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 1.08
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://sg.danny.cz/sg/p/${PN}-${PV}.tgz
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--mandir=/usr/share/man \
		&& \
		$(run_make)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

DESCRIPTION_${P} = sdparm
RDEPENDS_${P} = libc6
FILES_${P} = /usr/bin/sdparm

call[[ ipkbox ]]

]]package
