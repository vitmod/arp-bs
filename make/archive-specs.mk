
URL3=http://archive.stlinux.com/stlinux/2.3/STLinux/sh4
URL3U=http://archive.stlinux.com/stlinux/2.3/updates/RPMS/sh4
URL4=http://archive.stlinux.com/stlinux/2.4/STLinux/sh4
URL4U=http://archive.stlinux.com/stlinux/2.4/updates/RPMS/sh4

URL3S=http://archive.stlinux.com/stlinux/2.3/SRPMS
URL3SU=http://archive.stlinux.com/stlinux/2.3/updates/SRPMS
URL4S=http://archive.stlinux.com/stlinux/2.4/SRPMS
URL4SU=http://archive.stlinux.com/stlinux/2.4/updates/SRPMS


$(archivedir)/stlinux23-sh4-%.sh4.rpm:
	rm -rf $(archivedir)/$(notdir $@)
	$(WGET) $(archivedir) $(URL3)/$(notdir $@) || $(WGET) $(archivedir) $(URL3U)/$(notdir $@)

$(archivedir)/stlinux24-sh4-%.sh4.rpm:
	rm -rf $(archivedir)/$(notdir $@)
	$(WGET) $(archivedir) $(URL4)/$(notdir $@) || $(WGET) $(archivedir) $(URL4U)/$(notdir $@)

$(archivedir)/stlinux23-host-%.src.rpm $(archivedir)/stlinux23-cross-%.src.rpm $(archivedir)/stlinux23-target-%.src.rpm:
	rm -rf $(archivedir)/$(notdir $@)
	$(WGET) $(archivedir) $(URL3S)/$(notdir $@) || $(WGET) $(archivedir) $(URL3SU)/$(notdir $@)

$(archivedir)/stlinux24-host-%.src.rpm $(archivedir)/stlinux24-cross-%.src.rpm $(archivedir)/stlinux24-target-%.src.rpm:
	rm -rf $(archivedir)/$(notdir $@)
	$(WGET) $(archivedir) $(URL4S)/$(notdir $@) || $(WGET) $(archivedir) $(URL4SU)/$(notdir $@)
