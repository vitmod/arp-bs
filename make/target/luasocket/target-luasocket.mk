#
# AR-P buildsystem smart Makefile
#
package[[ target_luasocket

BDEPENDS_${P} = $(target_glibc) $(target_lua)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://github.com/diegonehab/luasocket.git
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_prepare_post: $(TARGET_${P}).do_prepare
	set -e; \
	cd $(DIR_${P}); \
		sed -i -e "s@LD_linux=gcc@LD_LINUX=$(target)-gcc@" -e "s@CC_linux=gcc@CC_LINUX=$(target)-gcc -L$(target)/usr/lib@" -e "s@DESTDIR=@DESTDIR=$(target)/usr@" src/makefile;
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare_post
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		$(run_make) all CC=$(target)-gcc LD=$(target)-gcc LUAV=$(LUA_VER_SHORT) LUAINC_linux=$(targetprefix)/usr/include
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install LUAPREFIX_linux=/ LUAV=$(LUA_VER_SHORT) DESTDIR=$(PKDIR)/usr
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Lua module binding socket
RDEPENDS_${P} = liblua
FILES_${P} = /usr/share/lua/* /usr/lib/*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package