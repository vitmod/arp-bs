#
# AR-P buildsystem smart Makefile
#
package[[ target_opkg

BDEPENDS_${P} = $(target_glibc) $(target_zlib) $(target_libarchive)

PV_${P} = 0.3.3
PR_${P} = 2
PACKAGE_ARCH_${P} = $(box_arch)

call[[ base ]]

rule[[
  extract:https://git.yoctoproject.org/cgit/cgit.cgi/${PN}/snapshot/${PN}-${PV}.tar.gz
  patch:file://${PN}.patch
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./autogen.sh && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-curl \
			--disable-gpg \
			--with-opkglibdir=/usr/lib \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)

	$(INSTALL_DIR) $(PKDIR)/etc/opkg
	( echo "arch all 1" ; \
	  echo "arch sh4 10"; \
	  echo "arch $(box_arch) 16"; \
	  echo "option cache_dir /var/cache/opkg"; \
	  echo "option lists_dir /usr/lib/opkg/lists"; \
	  echo "option info_dir /usr/lib/opkg/info"; \
	  echo "option status_file /usr/lib/opkg/status"; \
	  echo "option lock_file /var/run/opkg.lock";\
	) >> $(PKDIR)/etc/opkg/opkg.conf
	ln -sf opkg $(PKDIR)/usr/bin/ipkg-cl
	ln -sf opkg $(PKDIR)/usr/bin/opkg-cl
	ln -sf opkg $(PKDIR)/usr/bin/ipkg
	$(INSTALL) -c -m755 ${SDIR}/modprobe $(PKDIR)/usr/share/opkg/intercept/modprobe
	touch $@

NAME_${P} = ${PN}
DESCRIPTION_${P} = lightweight package management system
RDEPENDS_${P} = libarchive
FILES_${P} = \
	/etc/opkg \
	/usr/bin \
	/usr/share/opkg/intercept \
	/usr/lib/libopkg.so.*

call[[ ipkbox ]]


]]package
