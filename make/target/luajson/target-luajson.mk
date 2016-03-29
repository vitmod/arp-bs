#
# AR-P buildsystem smart Makefile
#
package[[ target_luajson

BDEPENDS_${P} = $(target_glibc) $(target_lua)

PV_${P} = 14
PR_${P} = 1

call[[ base ]]

rule[[
  pdircreate:${PN}-${PV}
  nothing:http://regex.info/code/JSON.lua
]]rule

call[[ base_do_prepare ]]

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	$(INSTALL_DIR) $(PKDIR)/usr/share/lua/$(LUA_VER_SHORT)
	cd $(DIR_${P}) && \
	$(INSTALL_FILE) $(DIR_${P})/JSON.lua $(PKDIR)/usr/share/lua/$(LUA_VER_SHORT)/json.lua
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Simple JSON Encode/Decode in Pure Lua
RDEPENDS_${P} = liblua
FILES_${P} = /usr/share/lua/*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
