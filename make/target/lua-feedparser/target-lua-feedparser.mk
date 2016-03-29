#
# AR-P buildsystem smart Makefile
#
package[[ target_lua_feedparser

BDEPENDS_${P} = $(target_glibc) $(target_lua) $(target_luasocket) $(target_luaexpat)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://github.com/slact/lua-feedparser.git
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_prepare_post: $(TARGET_${P}).do_prepare
	set -e; \
	cd $(DIR_${P}); \
		sed -i -e "s/^PREFIX.*//" -e "s/^LUA_DIR.*//" Makefile;
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare_post
	$(PKDIR_clean)
	$(INSTALL_DIR) $(PKDIR)/usr/share/lua/$(LUA_VER_SHORT)
	cd $(DIR_${P}) && \
	$(run_make) install LUA_DIR=$(PKDIR)/usr/share/lua/$(LUA_VER_SHORT)
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Lua module binding feedparser
RDEPENDS_${P} = liblua luasocket luaexpat
FILES_${P} = /usr/share/lua/*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package