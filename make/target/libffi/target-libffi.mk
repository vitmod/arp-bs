#
# AR-P buildsystem smart Makefile
#
package[[ target_libffi

BDEPENDS_${P} = $(target_glibc)

PV_${P} = 3.2.1
PR_${P} = 1

DESCRIPTION_${P} = A portable foreign function interface library \
 The `libffi' library provides a portable, high level programming \
 interface to various calling conventions.  This allows a programmer to \
 call any function specified by a call interface description at run time. \
 FFI stands for Foreign Function Interface.  A foreign function interface \
 is the popular name for the interface that allows code written in one \
 language to call code written in another language.  The `libffi' library \
 really only provides the lowest, machine dependent layer of a fully \
 featured foreign function interface.  A layer must exist above `libffi' \
 that handles type conversions for values passed between the two languages.

call[[ base ]]

rule[[
  extract:ftp://sourceware.org/pub/${PN}/${PN}-${PV}.tar.gz
  patch:file://${PN}.patch
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr \
			--disable-static \
			--enable-builddir=libffi \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libffi6
RDEPENDS_${P} = libc6
FILES_${P} = /usr/lib/libffi.so.*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
