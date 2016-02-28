#
# CROSS-FILESYSTEM
#
package[[ cross_filesystem

BDEPENDS_${P} = $(meta_host)

call[[ chain ]]

$(TARGET_${P}).do_install: $(TARGET_${P}).do_depends
	install -d $(crossprefix)
	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_install
$(TARGET_${P}).clean: $(TARGET_${P}).clean_childs

]]package
