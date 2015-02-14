#
# AR-P buildsystem smart Makefile
#
package[[ target_udpxy

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 1.0.23-9
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://www.udpxy.com/download/1_23/${PN}.${PV}-prod.tar.gz
]]rule
MAKE_FLAGS_${P} = \
	STRIP=$(crossprefix)/bin/sh4-linux-strip \
	PREFIX=/usr


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		export CC=sh4-linux-gcc && \
		make $(MAKE_FLAGS_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && make $(MAKE_FLAGS_${P}) install-strip DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]
call[[ ipkbox ]]

DESCRIPTION_${P} = udp to http stream proxy

RDEPENDS_${P} = 
FILES_${P} = /usr/bin/udpxy



]]package
