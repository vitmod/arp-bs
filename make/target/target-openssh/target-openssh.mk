#
# OPENSSH
#
package[[ target_openssh

BDEPENDS_${P} = $(target_openssl) $(target_zlib)

PV_${P} = 7.1p1
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://artfiles.org/openbsd/OpenSSH/portable/${PN}-${PV}.tar.gz
]]rule

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		CC=$(target)-gcc && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--sysconfdir=/etc/ssh \
			--libexecdir=/sbin \
			--disable-strip \
			--with-privsep-path=/var/empty \
			--with-cppflags="-pipe -Os -I$(targetprefix)/usr/include" \
			--with-ldflags=-"L$(targetprefix)/usr/lib" \
		&& \
		$(run_make) all
#		$(target)-strip -s nmap
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && make install DESTDIR=$(PKDIR)
	sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' $(PKDIR)/etc/ssh/sshd_config
	$(INSTALL_DIR) $(PKDIR)/etc/init.d
	$(INSTALL_BIN) $(DIR_${P})/opensshd.init $(PKDIR)/etc/init.d/sshd

	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = OpenSSH provides end-to-end encrypted replacement of applications such as telnet, rlogin, and ftp.
FILES_${P} = /usr/bin/* /usr/sbin/* /etc/ssh/* /sbin/* /var/* /etc/init.d/*

define postinst_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ sshd start 44 S . stop 30 0 6 .
$$OPKG_OFFLINE_ROOT/ addgroup -g 74 -S  sshd
$$OPKG_OFFLINE_ROOT/ adduser -S -H sshd sshd
endef

define prerm_${P}
#!/bin/sh
update-rc.d -f -r $$OPKG_OFFLINE_ROOT/ sshd remove
endef

call[[ ipkbox ]]

]]package
