#
# CROSS GDB
#
package[[ cross_gdb

BDEPENDS_${P} = $(cross_filesystem)

PV_${P} = 7.6
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://ptxdist.sat-universum.de/${PN}-${PV}-stlinux.tar.bz2
#patch:file://${PN}-${PV}.patch
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		./configure \
			--build=$(build) \
			--host=$(build) \
			--prefix=$(crossprefix) \
			--target=sh4-linux \
			--with-sysroot=$(targetprefix) \
			--with-separate-debug-dir=$(targetprefix) \
			--disable-gdbtk \
			--disable-werror \
			--with-python=/usr/bin/python \
			--enable-linux-kernel-aware \
			--enable-shtdi \
		&& \
		$(run_make)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
		make install DESTDIR=$(PKDIR)
	rm -rf $(PKDIR)/$(crossprefix)/share/locale
	rm -rf $(PKDIR)/$(crossprefix)/lib/libiberty.a
	touch $@

call[[ ipk ]]

]]package
