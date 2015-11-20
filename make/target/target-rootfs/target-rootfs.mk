#
# AR-P buildsystem smart Makefile
#
package[[ target_rootfs

BDEPENDS_${P} = $(target_glibc) $(target_gcc) $(target_gcc_lib) $(target_base_files) $(target_driver) $(target_netbase) $(target_opkg) $(target_busybox) $(target_base_passwd) \
$(target_ustslave) $(target_sysvinit) $(target_devinit) $(target_udev) $(target_lirc) $(target_vsftpd) $(target_ethtool) $(target_fonts) \
$(target_fp_control) $(target_stfbcontrol) $(target_libfribidi) $(target_showiframe) $(target_portmap) $(target_firmware) $(target_bootelf) $(target_util_linux) $(target_e2fsprogs) $(target_wget) \
$(target_udev_rules) $(target_bootlogo) $(target_flash_tools) $(target_rfkill) $(target_distro_feed_configs) $(target_initscripts) $(target_update_rcd) \
$(target_streamripper) $(target_libbz2)

# core system libraries, binaries and scripts
opkg_my_list = \
	sysvinit \
	devinit \
	udev \
	udev-rules \
	initscripts \
	update-rc.d \
	busybox \
	vsftpd \
	base-passwd \
	base-files \
	netbase \
	opkg \
	distro-feed-configs \
	libz1 \
	libbz2 \
	libc6 \
	libgcc1 \
	libncurses5 \
	wget

# netutils binaries and tools
opkg_my_list += \
	portmap \
	vsftpd \
	ethtool

# kernel with firmware and modules
opkg_my_list += \
	boot-elf \
	bootlogo \
	firmware \
	ustslave \
	lirc \
	fp-control \
	stfbcontrol \
	showiframe \
	linux-kernel \
	kernel-module-avs \
	kernel-module-bpamem \
	kernel-module-cec \
	kernel-module-compcache \
	kernel-module-cpu-frequ \
	kernel-module-e2-proc \
	kernel-module-encrypt \
	kernel-module-frontcontroller \
	kernel-dvb-modules-stv090x \
	kernel-module-multicom \
	kernel-module-player2 \
	kernel-module-ptinp \
	kernel-module-simu-button \
	kernel-module-smartcard \
	kernel-module-stgfb

ifneq (,$(wildcard $(ipkbox)/kernel-module-ptinp*))
opkg_my_list += \
	kernel-module-ptinp
else
opkg_my_list += \
	kernel-module-pti
endif

ifdef CONFIG_HL101
opkg_my_list += \
	kernel-module-cic
endif

#extras

ifdef CONFIG_WLAN_SUPPORT
BDEPENDS_${P} += $(target_wireless_tools) $(target_firmware_wlan) $(target_compat_wireless)
opkg_my_list += \
	wireless-tools \
	kernel-module-rt2870sta \
	kernel-module-rt3070sta \
	kernel-module-rt5370sta \
	kernel-module-rtl8192cu \
	kernel-module-rtl871x \
	kernel-module-rtl8188eu \
	kernel-module-ath9k-htc \
	kernel-module-rt73usb
endif
ifdef CONFIG_3G_SUPPORT
BDEPENDS_${P} += $(target_modem_scripts) $(target_usb_modeswitch) $(target_pppd)
opkg_my_list += modem-scripts usb-modeswitch
endif
ifdef CONFIG_NTFS_3G_SUPPORT
BDEPENDS_${P} += $(target_ntfs_3g)
opkg_my_list += ntfs-3g
endif
ifdef CONFIG_IPTABLES_SUPPORT
BDEPENDS_${P} += $(target_iptables)
opkg_my_list += iptables
endif

#########################################################################################
# enigma2
ifdef CONFIG_BUILD_ENIGMA2
BDEPENDS_${P} += $(target_enigma2) $(target_python) $(target_tuxbox_configs) $(target_hotplug_e2_helper) $(target_python_pycrypto)
opkg_my_list += \
	config-satellites \
	config-cables \
	config-terrestrial \
	config-timezone \
	hotplug-e2-helper \
	enigma2 \
	enigma2-plugin-extensions-cutlisteditor \
	enigma2-plugin-extensions-dvdplayer \
	enigma2-plugin-extensions-graphmultiepg \
	enigma2-plugin-extensions-mediascanner \
	enigma2-plugin-extensions-mediaplayer \
	enigma2-plugin-extensions-modemsettings \
	enigma2-plugin-extensions-pictureplayer \
	enigma2-plugin-systemplugins-cablescan \
	enigma2-plugin-systemplugins-defaultservicesscanner \
	enigma2-plugin-systemplugins-diseqctester \
	enigma2-plugin-systemplugins-hdmicec \
	enigma2-plugin-systemplugins-hotplug \
	enigma2-plugin-systemplugins-keymapmanager \
	enigma2-plugin-systemplugins-networkwizard \
	enigma2-plugin-systemplugins-osd3dsetup \
	enigma2-plugin-systemplugins-osdpositionsetup \
	enigma2-plugin-systemplugins-positionersetup \
	enigma2-plugin-systemplugins-satelliteequipmentcontrol \
	enigma2-plugin-systemplugins-satfinder \
	enigma2-plugin-systemplugins-skinselector \
	enigma2-plugin-systemplugins-softwaremanager \
	enigma2-plugin-systemplugins-minivfd-icons \
	enigma2-plugin-systemplugins-videoclippingsetup \
	enigma2-plugin-systemplugins-videoenhancement \
	enigma2-plugin-systemplugins-videotune \
	enigma2-plugin-systemplugins-videomode
ifdef CONFIG_SPARK7162
opkg_my_list += \
	enigma2-plugin-systemplugins-uniontunertype
endif
ifdef CONFIG_WLAN_SUPPORT
BDEPENDS_${P} += $(target_python_wifi)
opkg_my_list += enigma2-plugin-systemplugins-wirelesslan
endif
endif

ifdef CONFIG_ENIGMA2_PLUGINS
BDEPENDS_${P} += $(target_enigma2_plugins)
endif

ifdef CONFIG_ENIGMA2_SKINS
BDEPENDS_${P} += $(target_enigma2_skins)
endif

ifdef CONFIG_ENIGMA2_EXTENSION_OPENWEBIF
BDEPENDS_${P} += $(target_openwebif)
opkg_my_list += enigma2-plugin-extensions-openwebif
endif

ifdef CONFIG_ENIGMA2_EXTENSION_WEBIF
opkg_my_list += enigma2-plugin-extensions-webinterface
endif

ifdef CONFIG_ENIGMA2_EXTENSION_MEDIAPORTAL
BDEPENDS_${P} += $(target_mediaportal)
opkg_my_list += enigma2-plugin-extensions-mediaportal
endif

ifdef CONFIG_PYTHON_LIVESTREAMER
BDEPENDS_${P} += $(target_python_livestreamer)
opkg_my_list += livestreamer
endif

ifdef CONFIG_ENIGMA2_SKIN_MEGAMOD
opkg_my_list += enigma2-plugin-skin-megamod
endif

ifdef CONFIG_ENIGMA2_SKIN_MAGIC
BDEPENDS_${P} += $(target_enigma2_skins_magic)
opkg_my_list += enigma2-plugin-skin-magic
endif

ifdef CONFIG_ENIGMA2_SKIN_PLIHD
BDEPENDS_${P} += $(target_enigma2_skins_plihd)
opkg_my_list += enigma2-plugin-skin-plihd
endif

ifdef CONFIG_ENIGMA2_SKIN_METROPOLISHD
BDEPENDS_${P} += $(target_enigma2_skins_metropolishd)
opkg_my_list += enigma2-plugin-skin-metropolishd
endif

ifdef CONFIG_ENIGMA2_EXTENSION_ALTSOFTCAM
BDEPENDS_${P} += $(target_plugin_alternativesoftcammanager)
opkg_my_list += enigma2-plugin-extensions-alternativesoftcammanager
endif

ifdef CONFIG_OSCAM
BDEPENDS_${P} += $(target_oscam)
opkg_my_list += enigma2-plugin-cams-oscam
endif

########################################################################################
#neutrino

ifdef CONFIG_BUILD_NEUTRINO
BDEPENDS_${P} += $(target_libid3tag) $(target_libvorbisidec) $(target_libcap) $(target_libmad) $(target_neutrino)
opkg_my_list += neutrino libblkid1
endif

#ifdef CONFIG_BUILD_HYBRID
#CONFIG_BUILD_ENIGMA2=y
#CONFIG_BUILD_NEUTRINO=y
#endif

########################################################################################
#xbmc
ifdef CONFIG_BUILD_XBMC
BDEPENDS_${P} += $(target_xbmc) $(target_libid3tag) $(target_libvorbisidec) $(target_libcap) $(target_libmad)
opkg_my_list += libblkid1
endif

#########################################################################################
PV_${P} = 0.1
PR_${P} = 7

RM_WORK_${P} = $(false)
$(info AAAA $(wildcard $(ipkbox)/kernel-module-ptinp*))
call[[ base ]]
#overwrite workdir
WORK_${P} = $(prefix)/release
DIR_${P} = $(WORK_${P})

call[[ base_do_prepare ]]
opkg_rootfs := opkg -f $(prefix)/opkg-box.conf -o $(DIR_${P})

$(TARGET_${P}).do_install: $(TARGET_${P}).do_prepare
	( echo "dest root /"; \
	  echo "arch $(box_arch) 16"; \
	  echo "arch sh4 10"; \
	  echo "arch all 1"; \
	  echo "src/gz box file://$(ipkbox)"; \
	) > $(prefix)/opkg-box.conf

	cd $(ipkbox) && \
		/usr/bin/python $(hostprefix)/bin/ipkg-make-index . > Packages && \
		cat Packages | gzip > Packages.gz
	install -d $(DIR_${P})/usr/lib/opkg

	export OPKG_OFFLINE_ROOT=$(DIR_${P}) && \
	$(opkg_rootfs) update && \
	$(opkg_rootfs) install --force-postinstall $(opkg_my_list)
#	add version
	echo "version=OpenAR-P_`date +%d-%m-%y-%T`_git-`git rev-list --count HEAD`" > $(DIR_${P})/etc/image-version
	echo "----------------------------------------------------------" >>          $(DIR_${P})/etc/image-version
	echo "----------------------------------------------------------" >>          $(DIR_${P})/etc/image-version
	cat $(buildprefix)/.config |grep -v '^#' |tr ' ' '\n' >>                      $(DIR_${P})/etc/image-version
	echo "OpenAR-P \n \l" > $(DIR_${P})/etc/issue
	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_install

# helps to fill DEPENDS list
$(TARGET_${P}).print_depends:
#	catch cat exitstatus and see stderr
	@cd $(ipkorigin) && cat $(addsuffix .origin,$(opkg_my_list)) 2>&1 |uniq

# some packages are installed due to rdepends of other ones
# we want to see all the installed packages and rebuild rootfs when any of them changes
$(TARGET_${P}).print_depends_all: $(TARGET_${P})
	set -e; \
	list=`$(opkg_rootfs) list-installed | cut -d ' ' -f 1`; \
	for x in $${list}; do \
		cat $(ipkorigin)/$${x}.origin || true; \
	done


]]package
