#
# AR-P buildsystem smart Makefile
#
package[[ target_luaexpat

BDEPENDS_${P} = $(target_glibc) $(target_lua) $(target_expat)

PV_${P} = 1.3.0
PR_${P} = 1

call[[ base ]]

rule[[
  extract:http://matthewwild.co.uk/projects/luaexpat/${PN}-${PV}.tar.gz
  patch:file://${PN}-${PV}.patch
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		$(run_make) $(MAKE_ARGS)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install PREFIX=$(PKDIR)/usr
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = LuaExpat is a SAX XML parser based on the Expat library
RDEPENDS_${P} = libexpat1 liblua
FILES_${P} = /usr/lib/lua/* /usr/share/lua/*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
