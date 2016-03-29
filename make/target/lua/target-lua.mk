#
# AR-P buildsystem smart Makefile
#
package[[ target_lua

BDEPENDS_${P} = $(target_glibc) $(target_ncurses) $(target_curl)

PV_${P} = 5.2.3
PR_${P} = 3

LUA_VER = ${PV}
LUA_VER_SHORT = 5.2
LUAPOSIX_VER = 31

call[[ base ]]

rule[[
  extract:http://www.lua.org/ftp/${PN}-${PV}.tar.gz
  git://github.com/luaposix/luaposix.git;r=release-v$(LUAPOSIX_VER)
  patch:file://liblua-${PV}-luaposix-$(LUAPOSIX_VER).patch
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_prepare_post: $(TARGET_${P}).do_prepare
	set -e; \
	cd $(DIR_${P})/luaposix.git/ext; cp posix/posix.c include/lua52compat.h ../../src/; cd ../..; \
	cd $(DIR_${P})/luaposix.git/lib; cp *.lua $(DIR_${P})/; cd ../..; \
	sed -i 's/<config.h>/"config.h"/' src/posix.c; \
	sed -i '/^#define/d' src/lua52compat.h; \
	sed -i 's@^#define LUA_ROOT.*@#define LUA_ROOT "/usr/"@' src/luaconf.h; \
	sed -i '/^#define LUA_USE_READLINE/d' src/luaconf.h; \
	sed -i 's/ -lreadline//' src/Makefile; \
	
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare_post
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		$(run_make) $(MAKE_ARGS) BUILDMODE=dynamic PKG_VERSION=$(LUA_VER) AR="$(target)-ar rcu" linux
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install INSTALL_TOP=$(PKDIR)/usr;  cp *.lua  $(PKDIR)/usr/share/lua/$(LUA_VER_SHORT)
	touch $@

call[[ ipk ]]

NAME_${P} = liblua
DESCRIPTION_${P} = Lua is a powerful, fast, lightweight, embeddable scripting language
RDEPENDS_${P} = libncurses5
FILES_${P} = /usr/bin/lua /usr/bin/luac /usr/lib/* /usr/share/lua/*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
