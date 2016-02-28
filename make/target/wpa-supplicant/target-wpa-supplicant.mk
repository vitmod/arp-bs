#
# AR-P buildsystem smart Makefile
#
package[[ target_wpa_supplicant

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 1.0
PR_${P} = 1

DIR_${P} = ${WORK}/wpa_supplicant-${PV}

call[[ base ]]

rule[[
  extract:http://hostap.epitest.fi/releases/wpa_supplicant-${PV}.tar.gz
  nothing:file://wpa_supplicant.config
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P})/wpa_supplicant && \
		mv ../wpa_supplicant.config .config && \
		$(run_make) $(MAKE_ARGS)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P})/wpa_supplicant && $(run_make) install DESTDIR=$(PKDIR) LIBDIR=/usr/lib BINDIR=/usr/sbin
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} =  Tools for the Linux Standard Wireless Extension Subsystem
FILES_${P} = /usr/sbin/*

call[[ ipkbox ]]

]]package
