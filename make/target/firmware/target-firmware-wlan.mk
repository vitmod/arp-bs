#
# AR-P buildsystem smart Makefile
#
package[[ target_firmware_wlan

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = git
PR_${P} = 4
PACKAGE_ARCH_${P} = all

DESCRIPTION_${P} = linux-firmware

call[[ base ]]

rule[[
  git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
  nothing:file://Wireless/*
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
	$(INSTALL_DIR) $(PKDIR)/lib/firmware/ && \
	$(INSTALL_DIR) $(PKDIR)/lib/firmware/rtl8188eu/ && \
	$(INSTALL_DIR) $(PKDIR)/lib/firmware/rtlwifi/ && \
	$(INSTALL_DIR) $(PKDIR)/etc/Wireless/RT2870STA/ && \
	$(INSTALL_DIR) $(PKDIR)/etc/Wireless/RT3070STA/ && \
	$(INSTALL_DIR) $(PKDIR)/etc/Wireless/MT7601U/ && \
	$(INSTALL_FILE) RT2870STA/RT2870STA.dat $(PKDIR)/etc/Wireless/RT2870STA/ && \
	$(INSTALL_FILE) MT7601U/RT2870STA.dat $(PKDIR)/etc/Wireless/MT7601U/ && \
	$(INSTALL_FILE) rt2870.bin $(PKDIR)/lib/firmware/ && \
	$(INSTALL_FILE) mt7601u.bin $(PKDIR)/lib/firmware/ && \
	$(INSTALL_FILE) RT3070STA/RT3070STA.dat $(PKDIR)/etc/Wireless/RT3070STA/ && \
	ln -sf /lib/firmware/rt2870.bin $(PKDIR)/lib/firmware/rt3070.bin && \
	ln -sf /lib/firmware/rt2870.bin $(PKDIR)/lib/firmware/rt5370.bin && \
	$(INSTALL_FILE) rtlwifi/rtl8188eufw.bin $(PKDIR)/lib/firmware/rtlwifi && \
	$(INSTALL_FILE) rtlwifi/rtl8192cufw.bin $(PKDIR)/lib/firmware/rtlwifi && \
	$(INSTALL_FILE) rtlwifi/rtl8192defw.bin $(PKDIR)/lib/firmware/rtlwifi && \
	$(INSTALL_FILE) rtlwifi/rtl8712u.bin $(PKDIR)/lib/firmware/rtlwifi && \
	$(INSTALL_FILE) htc_7010.fw $(PKDIR)/lib/firmware && \
	$(INSTALL_FILE) htc_9271.fw $(PKDIR)/lib/firmware && \
	$(INSTALL_FILE) carl9170-1.fw $(PKDIR)/lib/firmware && \
	$(INSTALL_FILE) rt73.bin $(PKDIR)/lib/firmware
	touch $@

PACKAGES_${P} = \
	firmware_mt7601u \
	firmware_rt2870 \
	firmware_rt3070 \
	firmware_rt5370 \
	firmware_rtl8188eu \
	firmware_rtl8192cu \
	firmware_rtl8192de \
	firmware_rtl8712u \
	firmware_carl9170 \
	firmware_ath9k_htc \
	firmware_rt73

FILES_firmware_rt2870 = \
	/lib/firmware/rt2870.bin \
	/etc/Wireless/RT2870STA/RT2870STA.dat

FILES_firmware_mt7601u = \
	/lib/firmware/mt7601u.bin \
	/etc/Wireless/MT7601U/RT2870STA.dat

FILES_firmware_rt3070 = \
	/lib/firmware/rt3070.bin \
	/etc/Wireless/RT3070STA/RT3070STA.dat
RDEPENDS_firmware_rt3070 = \
	firmware_rt2870

FILES_firmware_rt5370 = \
	/lib/firmware/rt5370.bin
RDEPENDS_firmware_rt5370 = \
	firmware_rt2870

FILES_firmware_rtl8188eu = \
	/lib/firmware/rtlwifi/rtl8188eufw.bin

FILES_firmware_rtl8192cu =\
	/lib/firmware/rtlwifi/rtl8192cufw.bin

FILES_firmware_rtl8192de =\
	/lib/firmware/rtlwifi/rtl8192defw.bin

FILES_firmware_rtl8712u = \
	/lib/firmware/rtlwifi/rtl8712u.bin

FILES_firmware_carl9170 =\
	/lib/firmware/carl9170-1.fw

FILES_firmware_ath9k_htc = \
	/lib/firmware/htc_7010.fw /lib/firmware/htc_9271.fw

FILES_firmware_rt73 = \
	/lib/firmware/rt73.bin

call[[ ipkbox ]]

]]package
