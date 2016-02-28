#
# AR-P buildsystem smart Makefile
#
package[[ target_libaacs

BDEPENDS_${P} = $(target_glibc) $(target_libgcrypt)

PV_${P} = 0.8.1
PR_${P} = 1

call[[ base ]]

rule[[
  extract:https://ftp.videolan.org/pub/videolan/${PN}/${PV}/${PN}-${PV}.tar.bz2
  patch:file://libaacs-buildfix.patch
  nothing:http://vlc-bluray.whoknowsmy.name/files/KEYDB.cfg
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-werror \
			--disable-extra-warnings \
			--disable-optimizations \
			--with-libgcrypt-prefix=$(targetprefix)/usr \
			--with-gpg-error-prefix=$(targetprefix)/usr \
			--prefix=/usr \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	$(INSTALL_DIR) $(PKDIR)/root/.config/aacs/
	$(INSTALL_FILE) $(DIR_${P})/KEYDB.cfg $(PKDIR)/root/.config/aacs/ 
	
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = libaacs is a research project to implement the Advanced Access Content System specification.
RDEPENDS_${P} = libc6 libgcrypt libgpg_error
FILES_${P} = /usr/lib/libaacs.so.* /root/.config/aacs/KEYDB.cfg
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
