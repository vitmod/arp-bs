#
# XBMC-PVR-ADDONS
#
ifeq ($(strip $(CONFIG_BUILD_XBMC)),y)
package[[ target_xbmc_pvr_addons

BDEPENDS_${P} = $(target_glibc) $(target_xbmc)

PV_${P} = git
PR_${P} = 1
PACKAGE_ARCH_${P} = $(box_arch)

DESCRIPTION_${P} = pvr addons for xbmc

call[[ base ]]

rule[[
  git://github.com/opdenkamp/xbmc-pvr-addons.git:b=frodo
  patch:file://xbmc-pvr-addons-arch-sh-support.diff
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./bootstrap && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-static \
			--disable-mysql \
			--enable-addons-with-dependencies \
			--enable-shared \
			&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

# Packaging
##########################################################################################

PACKAGES_${P} = xbmc_pvr_addons_argustv \
		xbmc_pvr_addons_demo \
		xbmc_pvr_addons_dvblink \
		xbmc_pvr_addons_dvbviewer \
		xbmc_pvr_addons_hts \
		xbmc_pvr_addons_iptvsimple \
		xbmc_pvr_addons_mediaportal \
		xbmc_pvr_addons_nextpvr \
		xbmc_pvr_addons_njoy \
		xbmc_pvr_addons_vdr \
		xbmc_pvr_addons_vuplus \
		xbmc_pvr_addons_wmc

RDEPENDS_${P} = xbms_core

SRC_URI_${P} = git://github.com/opdenkamp/xbmc-pvr-addons

FILES_xbmc_pvr_addons_argustv = \
	/usr/lib/xbmc/addons/pvr.argustv/* \
	/usr/share/xbmc/addons/pvr.argustv/*
FILES_xbmc_pvr_addons_demo = \
	/usr/lib/xbmc/addons/pvr.demo/* \
	/usr/share/xbmc/addons/pvr.demo/*
FILES_xbmc_pvr_addons_dvblink = \
	/usr/lib/xbmc/addons/pvr.dvblink/* \
	/usr/share/xbmc/addons/pvr.dvblink/*
FILES_xbmc_pvr_addons_dvbviewer = \
	/usr/lib/xbmc/addons/pvr.dvbviewer/* \
	/usr/share/xbmc/addons/pvr.dvbviewer/*
FILES_xbmc_pvr_addons_hts = \
	/usr/lib/xbmc/addons/pvr.hts/* \
	/usr/share/xbmc/addons/pvr.hts/*
FILES_xbmc_pvr_addons_iptvsimple = \
	/usr/lib/xbmc/addons/pvr.iptvsimple/* \
	/usr/share/xbmc/addons/pvr.iptvsimple/*
FILES_xbmc_pvr_addons_mediaportal = \
	/usr/lib/xbmc/addons/pvr.mediaportal.tvserver/* \
	/usr/share/xbmc/addons/pvr.mediaportal.tvserver/*
FILES_xbmc_pvr_addons_nextpvr = \
	/usr/lib/xbmc/addons/pvr.nextpvr/* \
	/usr/share/xbmc/addons/pvr.nextpvr/*
FILES_xbmc_pvr_addons_njoy = \
	/usr/lib/xbmc/addons/pvr.njoy/* \
	/usr/share/xbmc/addons/pvr.njoy/*
FILES_xbmc_pvr_addons_vdr = \
	/usr/lib/xbmc/addons/pvr.vdr.vnsi/* \
	/usr/share/xbmc/addons/pvr.vdr.vnsi/*
FILES_xbmc_pvr_addons_vuplus = \
	/usr/lib/xbmc/addons/pvr.vuplus/* \
	/usr/share/xbmc/addons/pvr.vuplus/*
FILES_xbmc_pvr_addons_wmc = \
	/usr/lib/xbmc/addons/pvr.wmc/* \
	/usr/share/xbmc/addons/pvr.wmc/*

call[[ ipkbox ]]

]]package
endif
