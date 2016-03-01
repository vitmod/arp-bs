#
# OPKG-HOST
#
package[[ host_opkg

BDEPENDS_${P} = $(host_filesystem) $(host_libarchive)

PV_${P} = 0.3.1
PR_${P} = 2

call[[ base ]]

rule[[
  http://downloads.yoctoproject.org/releases/${PN}/${PN}-${PV}.tar.gz
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		export PATH=$(HOST_PATH) && \
		./autogen.sh && \
		./configure \
			PKG_CONFIG_PATH=$(hostprefix)/lib/pkgconfig \
			--prefix=$(hostprefix) \
		&& \
		$(run_make)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd ${DIR} && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ installer ]]

]]package