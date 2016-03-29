#
# AR-P buildsystem smart Makefile
#
package[[ target_luacurl

BDEPENDS_${P} = $(target_glibc) $(target_lua) $(target_curl)

PV_${P} = git
PR_${P} = 2

call[[ base ]]

rule[[
  git://github.com/Lua-cURL/Lua-cURLv3.git
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		DESTDIR=$(targetprefix)/ \
		LIBDIR=$(targetprefix)/usr/lib \
		LUA_INC=$(targetprefix)/usr/include \
		$(run_make) $(MAKE_ARGS) LUAV=$(LUA_VER_SHORT)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install LUA_CMOD=/usr/lib/lua/$(LUA_VER_SHORT) LUA_LMOD=/usr/share/lua/$(LUA_VER_SHORT) DESTDIR=$(PKDIR)/
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Lua module binding CURL
RDEPENDS_${P} = liblua
FILES_${P} = /usr/share/lua/*  /usr/lib/lua/*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
