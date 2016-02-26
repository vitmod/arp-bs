#
# AR-P buildsystem smart Makefile
#
package[[ target_usb_modeswitch

BDEPENDS_${P} = $(target_libusb) $(target_libusb_compat) $(target_usb_modeswitch_data)

PV_${P} = 2.3.0
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://www.draisberghof.de/usb_modeswitch/${PN}-${PV}.tar.bz2
  patch:file://${PN}.patch
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		$(run_make) $(MAKE_ARGS)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

DESCRIPTION_${P} = usb-modeswitch
RDEPENDS_${P} = libusb-0.1 libusb-1.0 usb_modeswitch_data
FILES_${P} = /etc/* /lib/udev/* /usr/sbin/*

call[[ ipkbox ]]

]]package
