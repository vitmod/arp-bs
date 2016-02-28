#
# AR-P buildsystem smart Makefile
#
package[[ target_tremor

BDEPENDS_${P} = $(target_glibc) $(target_libogg)

PV_${P} = svn
PR_${P} = 1

call[[ base ]]

rule[[
  svn://svn.xiph.org/trunk/Tremor;r=18221
  patch:file://tremor-configure.patch
]]rule

call[[ svn ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./autogen.sh \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libvorbisidec1
DESCRIPTION_${P} = tremor is a fixed point implementation of the vorbis codec.
RDEPENDS_${P} = libogg0 libc6
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef
FILES_${P} = /usr/lib/*.so.*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
