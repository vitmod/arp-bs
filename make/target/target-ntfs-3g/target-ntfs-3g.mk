#
# AR-P buildsystem smart Makefile
#
package[[ target_ntfs_3g

BDEPENDS_${P} = $(target_glibc) $(target_fuse)

PV_${P} = 2015.3.14
PR_${P} = 1
PN_${P} = ntfs-3g_ntfsprogs

call[[ base ]]

rule[[
  extract:http://tuxera.com/opensource/${PN}-${PV}.tgz
]]rule


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-ldconfig \
			--enable-shared \
			--exec-prefix=/usr \
		&& \
		$(run_make)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

PACKAGES_${P} = ntfs_3g libntfs_3g85 ntfsprogs

DESCRIPTION_${P} = The NTFS-3G driver is an open source, freely available NTFS driver for \
 Linux with read and write support.

RDEPENDS_ntfs_3g = libc6 libfuse2 libntfs_3g85
FILES_ntfs_3g = /sbin/mount.n* /usr/bin/ntfs-3*

RDEPENDS_ntfsprogs = libc6 libntfs_3g85
FILES_ntfsprogs = \
	/sbin/mount.lowntfs-3g \
	/sbin/mkfs.ntfs \
	/usr/bin/lowntfs-3g \
	/usr/bin/ntfscat \
	/usr/bin/ntfscluster \
	/usr/bin/ntfscmp \
	/usr/bin/ntfsfix \
	/usr/bin/ntfsinfo \
	/usr/bin/ntfsls \
	/usr/sbin/mkntfs \
	/usr/sbin/ntfsclone \
	/usr/sbin/ntfscp \
	/usr/sbin/ntfslabel \
	/usr/sbin/ntfsresize \
	/usr/sbin/ntfsundelete

RDEPENDS_libntfs_3g85 = libc6
define postinst_libntfs_3g85
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_libntfs_3g85 = /usr/lib/libntfs-3g.so.*

call[[ ipkbox ]]

]]package
