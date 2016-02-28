#
# AR-P buildsystem smart Makefile
#
package[[ target_gst_plugin_subsink

BDEPENDS_${P} = $(target_glibc) $(target_gstreamer) $(target_gst_plugins_base) $(target_gst_plugins_good) $(target_gst_plugins_bad) $(target_gst_plugins_ugly) $(target_gst_plugins_fluendo_mpegdemux)

ifeq ($(strip $(CONFIG_GSTREAMER_GIT)),y)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://github.com/OpenPLi/gst-plugin-subsink.git;r=0cb20d6024
]]rule

call[[ git ]]

else

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://github.com/OpenPLi/gst-plugin-subsink.git
]]rule

call[[ git ]]

endif

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_${P}) && \
	touch NEWS README AUTHORS ChangeLog && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
	autoheader && \
	autoconf && \
	automake --add-missing && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--build=$(build) \
		--prefix=/usr \
		--enable-orc \
	&& \
	$(run_make)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = GStreamer subsink plugin
RDEPENDS_${P} = libglib libxml2 libffi6 libz1 libc6 gstreamer
FILES_${P} = /usr/lib/gstreamer-0.10/libgstsubsink.so
define postinst_${P}
#!/bin/sh
$$OPKG_OFFLINE_ROOT/sbin/ldconfig
endef

call[[ ipkbox ]]

]]package
