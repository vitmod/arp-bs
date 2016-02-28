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

$(TARGET_${P}).do_install: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		export PATH=$(HOST_PATH) && \
		./autogen.sh && \
		./configure \
			PKG_CONFIG_PATH=$(hostprefix)/lib/pkgconfig \
			--prefix=$(hostprefix) \
		&& \
		$(run_make) && \
		$(run_make) install

	echo '$(opkg_script)' > $(hostprefix)/bin/opkg-safe
	chmod +x $(hostprefix)/bin/opkg-safe

	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_install

]]package