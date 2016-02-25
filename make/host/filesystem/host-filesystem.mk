#
# HOST-FILESYSTEM
#
package[[ host_filesystem

BDEPENDS_${P} =

PV_${P} = 0.1
PR_${P} = 2

call[[ base ]]

$(TARGET_${P}).do_install: $(DEPENDS_${P})
	install -d $(workprefix)
	install -d $(specsprefix)
	install -d $(sourcesprefix)

	install -d $(ipkhost)
	install -d $(hostprefix)
	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_install

]]package
