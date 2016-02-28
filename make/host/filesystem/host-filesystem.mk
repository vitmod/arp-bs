#
# HOST-FILESYSTEM
#
package[[ host_filesystem

BDEPENDS_${P} =

call[[ chain ]]

$(TARGET_${P}).do_install: $(TARGET_${P}).do_depends
	install -d $(workprefix)
	install -d $(specsprefix)
	install -d $(sourcesprefix)
	install -d $(tarprefix)
	install -d $(hostprefix)
	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_install

]]package
