#
# NMAP
#
package[[ target_nmap

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 6.47
PR_${P} = 1

call[[ base ]]

rule[[
  extract:https://${PN}.org/dist/${PN}-${PV}.tar.bz2
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-liblua \
			--without-nping \
			--without-ndiff \
			--without-nmap-update \
			--without-ncat \
			--without-openssl \
			--without-zenmap \
			--with-libpcap=internal \
			--with-pcap=linux \
			--enable-static \
		&& \
		make && \
		$(target)-strip -s nmap
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && make install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Command line portscanner.
FILES_${P} = /usr/bin/nmap

call[[ ipkbox ]]

]]package
