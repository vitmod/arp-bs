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

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		./configure \
			--build=$(build) \
			--host=$(build) \
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
