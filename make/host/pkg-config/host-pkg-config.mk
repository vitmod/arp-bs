#
# HOST PKGCONFIG
#
package[[ host_pkg_config

BDEPENDS_${P} = $(host_rpmconfig) $(host_autotools)

PV_${P} = 0.28
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://pkgconfig.freedesktop.org/releases/${PN}-${PV}.tar.gz
  patch:file://${PN}-${PV}.patch
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		./configure \
			--prefix=$(hostprefix) \
			--disable-host-tool \
			--with-pc_path=$(targetprefix)/usr/lib/pkgconfig \
		&& \
		$(run_make)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && \
		make install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

]]package
