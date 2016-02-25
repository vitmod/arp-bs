#
# TARGET-FILESYSTEM
#
package[[ target_filesystem

DEPENDS_${P} = build.env host-opkg-meta bootstrap-host

PV_${P} = 0.1
PR_${P} = 4

SRC_URI_${P} = empty

call[[ base ]]
call[[ ipk ]]

$(TARGET_${P}).do_package: $(DEPENDS_${P})
	install -d $(ipktarget)
	install -d $(ipkbox)
	install -d $(ipkorigin)
	install -d $(targetprefix)

	$(PKDIR_clean)
#	make aclocal happy
	install -d $(PKDIR)/usr/share/aclocal
#	empty package will not work
	touch $(PKDIR)/.stamp
	
	touch $@

]]package
