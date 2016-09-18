# installer
#############################################################################

# Installation chain has two connection endpoints
# Before  ${TARGET}.do_tar make shure that $(PKDIR) is ready to be packaged
# After   ${TARGET}.do_install you have files installed to sysroots
# Look at this sheme:
#   YOU_FILL_PKDIR_HERE <- ${TARGET}.do_tar <- INSTALLATION <- ${TARGET}.do_install <- YOU_HAVE_FILES_IN_SYSROOT
#
# We also have default connections to main chain
#   ${TARGET}.do_package <- ${TARGET}.do_tar
#                           ${TARGET}.do_install <- ${TARGET}


# Checks that all files are tracked correctly
# not raises an error, juts prints verbose info

installer-check-host installer-check-cross installer-check-target: installer-check-%:
	@echo "==> check $*"
	
	@echo 'Cleanup empty directories:'
	find $($*prefix) -type d -empty -print -delete
	
	cat $(DEPDIR)/$*-*.files |sort > /tmp/$@_db
	test -z "`cat /tmp/$@_db |uniq -d`"
	cd $($*prefix) && find . -type f -o -type l |sort > /tmp/$@_fs
	@echo 'Disowned files:'
	comm --check-order -23 /tmp/$@_fs /tmp/$@_db
	@echo 'Missing files:'
	comm --check-order -13 /tmp/$@_fs /tmp/$@_db
	@echo 'Duplicated files:'
	cat /tmp/$@_db |uniq -d
	rm -f /tmp/$@_fs /tmp/$@_db
	@echo

installer-check: installer-check-host installer-check-cross installer-check-target
.PHONY: installer-check-host installer-check-cross installer-check-target installer-check


# Adapt files for cross compiling
rewrite_libtool = \
	find $(PKDIR) -name "*.la" -type f -exec \
		perl -pi -e "s,^libdir=.*$$,libdir='$(targetprefix)/usr/lib'," {} \;
rewrite_dependency = \
	find $(PKDIR) -name "*.la" -type f -exec \
		perl -pi -e "s, /usr/lib, $(targetprefix)/usr/lib,g if /^dependency_libs/" {} \;
rewrite_pkgconfig = \
	find $(PKDIR) -name "*.pc" -type f -exec \
		perl -pi -e "s,^prefix=.*$$,prefix=$(targetprefix)/usr," {} \;
#FIXME: unpackaged 'cp'
rewrite_config = \
	cp $1 $(crossprefix)/bin/$(notdir $1) && \
	sed -e "s,^prefix=,prefix=$(targetprefix)," -i $(crossprefix)/bin/$(notdir $1)



function[[ installer
# SYSROOT is one of host, cross, target
SYSROOT_${P} ?= $(error undefined SYSROOT_${P})

# Actually PKDIR
ipkrootdir_${P} := ${WORK}/root
PREFIX_${P} := $(${SYSROOT}prefix)

TAR_${P} = $(tarprefix)/$(${P}).tar

$(TARGET_${P}).do_tar: $(TARGET_${P}).do_package
#	Fix files in PKDIR
ifeq (${SYSROOT},host)
	mv $(PKDIR)/$(hostprefix)/* $(PKDIR)
	rmdir -p $(PKDIR)/$(hostprefix)/ || true
endif
ifeq (${SYSROOT},cross)
	mv $(PKDIR)/$(crossprefix)/* $(PKDIR)
	rmdir -p $(PKDIR)/$(crossprefix)/ || true
endif
ifeq (${SYSROOT},target)
	$(rewrite_libtool)
	$(rewrite_dependency)
endif
#	Create archive
	cd $(PKDIR) && tar -cf ${TAR} .
	touch $@

$(TARGET_${P}).clean_tar:
	rm -f ${TAR}
	rm -f $(TARGET_${P}).do_tar


# List of files in sysroot stored in ${TARGET}.files
# Package might be removed later due to ${BREMOVES}, in this case we remove ${TARGET}.files
# However ${TARGET}.do_install remains for correct dependcy chain
# So at every moment all $(TARGET_*).files list is a snapshot of sysroots

$(TARGET_${P}).files $(TARGET_${P}).do_install: $(TARGET_${P}).%:
	@echo
	@echo "==> Installing ${P}"
	test -f ${TAR}
	
	tar -tf ${TAR} |grep -v '/$$' > $@_tar
	cd ${PREFIX} && cat $@_tar | perl -ne 'chomp; if(-e $$_) { exit 1; }'
	tar -k -xf ${TAR} -C ${PREFIX}
	
	mv $@_tar ${TARGET}.files
	rm -f ${TARGET}.rmfiles ${TARGET}.do_remove
	touch $@

$(TARGET_${P}).rmfiles $(TARGET_${P}).do_remove $(TARGET_${P}).do_preinstall: $(TARGET_${P}).%:
	@echo
	@echo "==> Removing ${P}"
	test ! -f ${TARGET}.files \
	|| (cd ${PREFIX} && cat ${TARGET}.files |sed 's/^/"/; s/$$/"/' |xargs rm)
	rm -f ${TARGET}.files
	touch $@


# ${TARGET}.do_install and ${TARGET}.do_remove are involved in build dependency chain
# ${TARGET}.files and ${TARGET}.rmfiles are for clean dependcy chain
# Clean and build chains must not overlap

# When install
# firstly, create tar archive
# secondly, remove all packages that we replace - ${BREMOVES}
$(foreach pkg,${BREMOVES},$(DEPDIR)/$(pkg).do_remove: ${TARGET}.do_tar)
# firdly, uninstall my old files
$(TARGET_${P}).do_preinstall: $(TARGET_${P}).do_tar
# finally, install files from my tar
$(TARGET_${P}).do_install: $(TARGET_${P}).do_preinstall $(foreach pkg,${BREMOVES},$(DEPDIR)/$(pkg).do_remove)

# When clean
# firstly, uninstall all packages that depend on me
${TARGET}.rmfiles: ${TARGET}.clean_childs
# secondly, remove our files
$(foreach pkg,${BREMOVES},$(DEPDIR)/$(pkg).files: | ${TARGET}.rmfiles)
# finally, reinstall files that were replaced
${TARGET}.clean_install: ${TARGET}.rmfiles $(foreach pkg,${BREMOVES},$(DEPDIR)/$(pkg).files)
	rm -f $(TARGET_${P}).do_install

$(TARGET_${P}).clean: $(TARGET_${P}).clean_install

# Integrate in default target
$(TARGET_${P}): $(TARGET_${P}).do_install

# Print file conflicts
$(TARGET_${P}).help_install: $(TARGET_${P}).do_tar
	@echo "==> Files conflict:"
	cd ${PREFIX} && tar -tf ${TAR} |grep -v '/$$' \
	| while read f; do test -f "$$f" && echo -e "\t$$f"; done

]]function


function[[ ipk
call[[ installer ]]
]]function
