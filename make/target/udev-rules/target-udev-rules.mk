#
# AR-P buildsystem smart Makefile
#
package[[ target_udev_rules

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 0.4
PR_${P} = 2

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  install:-d:$(PKDIR)/etc/udev/rules.d
  install_file:$(PKDIR)/etc/udev/rules.d/:file://60-dvb-ca.rules
  install_file:$(PKDIR)/etc/udev/rules.d/:file://65-event.rules
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(INSTALL_${P})
	touch $@

PACKAGES_${P} = udev-dvb-ca-rules udev-event-rules
DESCRIPTION_${P} = custom udev rules
FILES_udev_dvb_ca_rules = /etc/udev/rules.d/60-dvb-ca.rules
RDEPENDS_udev_dvb_ca_rules = udev
FILES_udev_event_rules = /etc/udev/rules.d/65-event.rules
RDEPENDS_udev_event_rules = udev

call[[ ipkbox ]]

]]package
