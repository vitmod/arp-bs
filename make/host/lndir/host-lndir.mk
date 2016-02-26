#
# LIBTOOL
#
package[[ host_lndir

BDEPENDS_${P} = $(host_ccache) $(host_automake)

PV_${P} = 1.0.3
PR_${P} = 2

call[[ base ]]

rule[[
  extract:http://ftp.x.org/pub/individual/util/${PN}-${PV}.tar.bz2
  patch:file://${PN}-no-xorg.patch
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		autoconf && \
		automake && \
		./configure \
			--prefix=$(hostprefix) \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)

	touch $@

call[[ ipk ]]

]]package