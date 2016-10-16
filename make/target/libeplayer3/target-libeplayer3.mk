#
# AR-P buildsystem smart Makefile
#
package[[ target_libeplayer3

BDEPENDS_${P} = $(target_ffmpeg) $(target_driver)
PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://github.com/Taapat/libeplayer3.git
  nothing:file://autogen.sh
  patch:file://makefile_am.patch
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./autogen.sh && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
		&& \
		$(run_make)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	cd $(DIR_${P}) && $(INSTALL_${P})
	  $(INSTALL_DIR) $(PKDIR)/usr/include/libeplayer3 && \
	  $(INSTALL_FILE) $(DIR_${P})/include/*.h $(PKDIR)/usr/include/libeplayer3
	touch $@
call[[ ipk ]]
	
DESCRIPTION_${P} = libeplayer3
PACKAGES_${P} = libeplayer3 libeplayer3-dev
RDEPENDS_libeplayer3 = kernel_module_player2 kernel_module_stgfb ffmpeg libass
FILES_libeplayer3 =/usr/lib/libeplayer3.so*
FILES_libeplayer3-dev =/usr/include/*

call[[ ipkbox ]]

]]package
