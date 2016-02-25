# installer
#############################################################################

installer-check-host installer-check-cross installer-check-target: installer-check-%:
	@echo "==> check $*"
	cat $(DEPDIR)/$*-*.files |sort > /tmp/$@_db
	test -z "`cat /tmp/$@_db |uniq -d`"
	cd $($*prefix) && find . -type f -o -type l |sort > /tmp/$@_fs
	@echo 'Disowned files:'
	comm --check-order -23 /tmp/$@_fs /tmp/$@_db
	@echo 'Missing files:'
	comm --check-order -13 /tmp/$@_fs /tmp/$@_db
	rm -f /tmp/$@_fs /tmp/$@_db
	@echo

installer-check: installer-check-host installer-check-cross installer-check-target
.PHONY: installer-check-host installer-check-cross installer-check-target installer-check

function[[ installer
# SYSROOT is one of host, cross, target
SYSROOT_${P} ?= $(error undefined SYSROOT_${P})

# Actually PKDIR
ipkrootdir_${P} := ${WORK}/root
PREFIX_${P} := $(${SYSROOT}prefix)

TAR_${P} = $(ipk${SYSROOT})/$(${P}).tar

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
	cd $(PKDIR) && tar -cf ${TAR} .
	touch $@

$(TARGET_${P}).clean_tar:
	rm -f ${TAR}
	rm -f $(TARGET_${P}).do_tar


# List of files in sysroot stored in ${TARGET}.files
# Package might be removed later due to BREMOVES, in this case we remove ${TARGET}.files
# However ${TARGET}.files_fake remains for correct dependcy chain

$(TARGET_${P}).files $(TARGET_${P}).files_fake: $(TARGET_${P}).files%:
	@echo
	@echo "==> Installing ${P}"
	test -f ${TAR}
	
	tar -tf ${TAR} |grep -v '/$$' > $@_tar
	cd ${PREFIX} && cat $@_tar |sed 's/^/"/; s/$$/"/' |xargs -n1 test ! -f
	tar -k -xf ${TAR} -C ${PREFIX}
	
	mv $@_tar ${TARGET}.files
	rm -f ${TARGET}.rmfiles
	touch $@

$(TARGET_${P}).rmfiles $(TARGET_${P}).rmfiles_fake: $(TARGET_${P}).rmfiles%:
	@echo
	@echo "==> Removing ${P}"
	cd ${PREFIX} && cat ${TARGET}.files |sed 's/^/"/; s/$$/"/' |xargs rm
	rm -f ${TARGET}.files
	touch $@

# ${TARGET}.files_fake and ${TARGET}.rmfiles_fake are involved in build dependency chain
# But ${TARGET}.files and ${TARGET}.rmfiles are for clean dependcy chain

$(TARGET_${P}).files_fake: $(TARGET_${P}).do_tar $(foreach pkg,${BREMOVES},$(DEPDIR)/$(pkg).rmfiles_fake)
# BREMOVES after packaged
$(foreach pkg,${BREMOVES},$(DEPDIR)/$(pkg).rmfiles_fake: ${TARGET}.do_tar)

# Target that keep track of reverse clean dependencies

$(TARGET_${P}).do_install: $(TARGET_${P}).files_fake
	echo -n > ${TARGET}.bdeps

#	When clean install
#	firstly, uninstall all packages that depend on me
#	note that here rule is provided for parent package

	$(foreach pkg,${BDEPENDS}, \
	  echo '$(DEPDIR)/$(pkg).rmfiles: ${TARGET}.clean_install' >> ${TARGET}.bdeps && \
	) true

#	secondly, remove our files
#	finally, reinstall files that were replaced

	$(foreach pkg,${BREMOVES}, \
	  echo '$(DEPDIR)/$(pkg).files: ${TARGET}.rmfiles' >> ${TARGET}.bdeps && \
	  echo '${TARGET}.clean_install: $(DEPDIR)/$(pkg).files' >> ${TARGET}.bdeps && \
	) true

	touch $@

# Include tracked reverse dependencies
-include $(TARGET_${P}).bdeps
# Thanks to traked bdeps it is in fact recursive clean_install
$(TARGET_${P}).clean_install: ${TARGET}.rmfiles
	@echo $@
	rm -f $(TARGET_${P}).bdeps
	rm -f $(TARGET_${P}).files_fake

# Integrate in default targets
$(TARGET_${P}): $(TARGET_${P}).do_install
$(TARGET_${P}).clean: $(TARGET_${P}).clean_install

]]function


function[[ ipk
call[[ installer ]]
]]function
