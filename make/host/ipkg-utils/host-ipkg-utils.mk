#
# IPKG-UTILS
#
package[[ host_ipkg_utils

BDEPENDS_${P} = $(host_filesystem)

PV_${P} = 050831
PR_${P} = 2

call[[ base ]]

rule[[
  extract:ftp://ftp.gwdg.de/pub/linux/handhelds/packages/${PN}/${PN}-${PV}.tar.gz
  patch:file://${PN}.diff
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	install -d $(PKDIR)/$(hostprefix)/bin
	cd $(DIR_${P}) && \
		$(run_make) all PREFIX=$(PKDIR)/$(hostprefix) && \
		$(run_make) install PREFIX=$(PKDIR)/$(hostprefix)
	touch $@

call[[ installer ]]

]]package
