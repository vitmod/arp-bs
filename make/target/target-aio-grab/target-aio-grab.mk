#
# AR-P buildsystem smart Makefile
#
package[[ target_aio_grab

BDEPENDS_${P} = $(target_glibc) $(target_libjpeg_turbo) $(target_libpng)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  nothing:git://github.com/OpenPLi/${PN}.git
  patch:file://${PN}.patch
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		autoreconf -i && \
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

DESCRIPTION_${P} = Screen grabber for Set-Top-Boxes
RDEPENDS_${P} += libpng16 libc6

call[[ ipkbox ]]

]]package
