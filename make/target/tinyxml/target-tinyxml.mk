#
# AR-P buildsystem smart Makefile
#
package[[ target_tinyxml

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 2.6.2
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${PN}_2_6_2.tar.gz
  pmove:${PN}:${PN}-${PV}
  patch:file://${PN}${PV}.patch
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_${P}) && \
		libtoolize -f -c && \
		$(BUILDENV) \
		 \
		$(run_make)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install PREFIX=$(PKDIR)/usr LD=sh4-linux-ld
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = tinyxml
RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/*.so.*
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
