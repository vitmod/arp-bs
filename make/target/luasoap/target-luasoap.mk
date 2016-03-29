#
# AR-P buildsystem smart Makefile
#
package[[ target_luasoap

BDEPENDS_${P} = $(target_glibc) $(target_lua)

PV_${P} = 3.0
PR_${P} = 1

call[[ base ]]

rule[[
  extract:https://github.com/downloads/tomasguisasola/${PN}/${PN}-${PV}.tar.gz
  patch:file://${PN}-${PV}.patch
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	$(INSTALL_DIR) $(PKDIR)/usr/share/lua/$(LUA_VER_SHORT)
	cd $(DIR_${P}) && \
	$(run_make) install LUA_DIR=$(PKDIR)/usr/share/lua/$(LUA_VER_SHORT)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = LuaExpat is a SAX XML parser based on the Expat library
RDEPENDS_${P} = liblua
FILES_${P} = /usr/lib/lua/* /usr/share/lua/*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
