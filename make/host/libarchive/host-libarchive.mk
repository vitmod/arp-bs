#
# AR-P buildsystem smart Makefile
#
package[[ host_libarchive

BDEPENDS_${P} = $(host_filesystem)

PV_${P} = 3.1.2
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://www.libarchive.org/downloads/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_install: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		./configure \
			--build=$(build) \
			--host=$(build) \
			--prefix=$(hostprefix) \
		&& \
		$(run_make) && \
		$(run_make) install
	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_install

]]package
