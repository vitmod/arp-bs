#
# AR-P buildsystem smart Makefile
#
package[[ target_aio_grab

BDEPENDS_${P} = $(target_glibc) $(target_libjpeg_turbo) $(target_libpng)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://github.com/OpenPLi/${PN}.git;b=master;r=009fd8b71d3fd974df4048cc4de038dcb94a778f
  patch:file://${PN}.patch
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

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
