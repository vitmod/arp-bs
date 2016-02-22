#
# AR-P buildsystem smart Makefile
#
package[[ target_luacurl

BDEPENDS_${P} = $(target_glibc) $(target_lua) $(target_curl)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  git://github.com/Lua-cURL/Lua-cURLv3.git
]]rule

call[[ git ]]

$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		DESTDIR=$(targetprefix)/ && \
		LIBDIR=$(targetprefix)/usr/lib && \
		LUA_INC=$(targetprefix)/usr/include && \
		$(run_make) all $(MAKE_ARGS)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install $(PKDIR)/usr/lib
	touch $@

call[[ ipk ]]

DESCRIPTION_${P} = Lua module binding CURL
RDEPENDS_${P} = liblua
FILES_${P} = ##/usr/bin/lua /usr/bin/luac /usr/lib/*

call[[ ipkbox ]]

]]package
