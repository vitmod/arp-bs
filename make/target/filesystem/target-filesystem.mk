#
# TARGET-FILESYSTEM
#
package[[ target_filesystem

DEPENDS_${P} = build.env $(meta_host)

call[[ chain ]]

$(TARGET_${P}).do_install: $(TARGET_${P}).do_depends
	install -d $(ipkbox)
	install -d $(ipkorigin)
	install -d $(targetprefix)
	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_install

]]package
