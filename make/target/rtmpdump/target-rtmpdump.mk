#
# AR-P buildsystem smart Makefile
#
package[[ target_rtmpdump

BDEPENDS_${P} = $(target_glibc) $(target_zlib) $(target_openssl)

PV_${P} = 2.4
PR_${P} = 2

call[[ base ]]

rule[[
  git://github.com/oe-alliance/${PN}.git
  patch:file://${PN}.patch
]]rule

call[[ git ]]

MAKE_FLAGS_${P} = \
	CROSS_COMPILE=$(target)- \
	prefix=/usr


call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		libtoolize -f -c && \
		$(run_make) $(MAKE_FLAGS_${P})
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) $(MAKE_FLAGS_${P}) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = librtmp1
DESCRIPTION_${P} = librtmp Real-Time Messaging Protocol API
RDEPENDS_${P} = libssl1 libz1 libc6 libcrypto1
define postinst_rtmpdump
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/librtmp.so.*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
