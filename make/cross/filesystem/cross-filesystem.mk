#
# CROSS-FILESYSTEM
#
package[[ cross_filesystem

BDEPENDS_${P} = $(meta_host)

call[[ chain ]]

$(TARGET_${P}).do_install: $(TARGET_${P}).do_depends
	install -d $(crossprefix)
	touch $@

]]package
