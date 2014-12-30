#
# OPKG-HOST
#
package[[ host_opkg

BDEPENDS_${P} = $(host_filesystem)

PV_${P} = 0.2.4
PR_${P} = 1

call[[ base ]]

rule[[
  http://downloads.yoctoproject.org/releases/${PN}/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_install: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		export PATH=$(HOST_PATH) && \
		./configure \
			--prefix=$(hostprefix) \
		&& \
		$(MAKE) && \
		$(MAKE) install
	ln -sf opkg-cl $(hostprefix)/bin/opkg
	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_install

]]package