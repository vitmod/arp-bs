#
# AR-P buildsystem smart Makefile
#
package[[ target_fakelocale

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = 1.0
PR_${P} = r6
PACKAGE_ARCH_${P} = all
KEEP_DOCS_${P} = $(true)

DESCRIPTION_${P} = LC_TIME locale support

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  extract:file://lctimelocales.tar.gz
  install:-d:$(PKDIR)/usr/lib/locale/fake/LC_MESSAGES
  install:-d:$(PKDIR)/usr/share/locale
  install_file:$(PKDIR)/usr/lib/locale/fake/LC_MESSAGES/SYS_LC_MESSAGES:file://SYS_LC_MESSAGES
  install_file:$(PKDIR)/usr/share/locale/locale.alias:file://locale.alias
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(INSTALL_${P}) && \
	cp -rp ../locales/* $(PKDIR)/usr/lib/locale && \
	LANGUAGES=" \
		ar_AE bg_BG ca_AD cs_CZ da_DK de_DE el_GR en_EN es_ES et_EE fa_IR fi_FI \
		fr_FR fy_NL he_IL hr_HR hu_HU is_IS it_IT lt_LT lv_LV nl_NL no_NO pl_PL pt_BR pt_PT \
		ru_RU sk_SK sl_SI sr_YU sv_SE th_TH tr_TR uk_UA" && \
	for lang in $${LANGUAGES}; do \
		ln -s ../fake/LC_MESSAGES $(PKDIR)/usr/lib/locale/$$lang/LC_MESSAGES; \
	done
	touch $@

call[[ ipkbox ]]

]]package
