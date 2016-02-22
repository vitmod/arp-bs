#
# AR-P buildsystem smart Makefile
#
package[[ target_tuxbox_configs

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 0.1
PR_${P} = 7
PACKAGE_ARCH_${P} = all

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  install:-d:$(PKDIR)/etc/tuxbox
  install:-d:$(PKDIR)/usr/share/zoneinfo
  install:-d:$(PKDIR)/usr/share/zoneinfo/Africa
  install:-d:$(PKDIR)/usr/share/zoneinfo/America
  install:-d:$(PKDIR)/usr/share/zoneinfo/Asia
  install:-d:$(PKDIR)/usr/share/zoneinfo/Atlantic
  install:-d:$(PKDIR)/usr/share/zoneinfo/Australia
  install:-d:$(PKDIR)/usr/share/zoneinfo/Brazil
  install:-d:$(PKDIR)/usr/share/zoneinfo/Canada
  install:-d:$(PKDIR)/usr/share/zoneinfo/Europe
  install:-d:$(PKDIR)/usr/share/zoneinfo/Pacific
  install_file:$(PKDIR)/etc/tuxbox:file://satellites.xml
  install_file:$(PKDIR)/etc/tuxbox:file://cables.xml
  install_file:$(PKDIR)/etc/tuxbox:file://terrestrial.xml
  install_file:$(PKDIR)/etc:file://timezone.xml
  install_file:$(PKDIR)/usr/share/zoneinfo/Africa:file://zoneinfo/Africa/*
  install_file:$(PKDIR)/usr/share/zoneinfo/America:file://zoneinfo/America/*
  install_file:$(PKDIR)/usr/share/zoneinfo/Asia:file://zoneinfo/Asia/*
  install_file:$(PKDIR)/usr/share/zoneinfo/Atlantic:file://zoneinfo/Atlantic/*
  install_file:$(PKDIR)/usr/share/zoneinfo/Australia:file://zoneinfo/Australia/*
  install_file:$(PKDIR)/usr/share/zoneinfo/Brazil:file://zoneinfo/Brazil/*
  install_file:$(PKDIR)/usr/share/zoneinfo/Canada:file://zoneinfo/Canada/*
  install_file:$(PKDIR)/usr/share/zoneinfo/Europe:file://zoneinfo/Europe/*
  install_file:$(PKDIR)/usr/share/zoneinfo/Pacific:file://zoneinfo/Pacific/*
  install_file:$(PKDIR)/usr/share/zoneinfo/:file://zoneinfo/*.tab
  install_file:$(PKDIR)/usr/share/zoneinfo/:file://zoneinfo/CE*
  install_file:$(PKDIR)/usr/share/zoneinfo/:file://zoneinfo/CS*
  install_file:$(PKDIR)/usr/share/zoneinfo/:file://zoneinfo/ES*
  install_file:$(PKDIR)/usr/share/zoneinfo/:file://zoneinfo/MS*
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(INSTALL_${P})
	touch $@

call[[ ipk ]]

PACKAGES_${P} = \
	config_satellites \
	config_cables \
	config_terrestrial \
	config_timezone

DESCRIPTION_config_cables = cables.xml config
FILES_config_cables = /etc/tuxbox/cables.xml

DESCRIPTION_config_terrestrial = terrestrial.xml config
FILES_config_terrestrial = /etc/tuxbox/terrestrial.xml

DESCRIPTION_config_satellites = satellites.xml config
FILES_config_satellites = /etc/tuxbox/satellites.xml

DESCRIPTION_config_timezone = timezones
FILES_config_timezone = /usr/share/zoneinfo/* /etc/timezone.xml

call[[ ipkbox ]]

]]package
