#
# TARGET-FILESYSTEM
#
package[[ target_filesystem

BDEPENDS_${P} = $(meta_host)
$(TARGET_${P}).do_depends: build.env

call[[ chain ]]

$(TARGET_${P}).do_install: $(TARGET_${P}).do_depends
	install -d $(ipkbox)
	install -d $(ipkorigin)
	install -d $(targetprefix)
	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_install
$(TARGET_${P}).clean: $(TARGET_${P}).clean_childs

]]package
