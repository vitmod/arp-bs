# header
#############################################################################

# in case you reference ${P} outside function[[ or package[[ directive
# it is expanded relative to current target name.
# targets must have only one '.' in their filenames !
P = $(subst -,_,$(basename $(notdir $@)))

function[[ header
# place in Makefile.in
${P} := $(subst _,-,${P})
TARGET_${P} := $(DEPDIR)/$(${P})
SYSROOT_${P} := $(word 1,$(subst _, ,${P}))
SDIR_${P} := $(dir $(buildprefix)/$(_thisfile))/files
]]function




# base
#############################################################################

PKDIR = $(if $(WORK_${P}),$(WORK_${P})/root,$(error WORK_${P}))

help::
	@echo run \'make all\' if really want to build everything
.PHONY: all

function[[ base
# place after variables definitions in *.mk file and before rule

# Check requirements
${P} ?= $(error undefined ${P})
PV_${P} ?= $(error undefined PV_${P})
PR_${P} ?= $(error undefined PR_${P})
TARGET_${P} ?= $(error undefined TARGET_${P})

WORK_${P} = $(workprefix)/${P}

# Provide defaults
PN_${P} ?= $(patsubst host-%,%,$(patsubst cross-%,%,$(patsubst target-%,%, $(${P}) )))
DIR_${P} ?= ${WORK}/${PN}-${PV}
PACKAGE_ARCH_${P} ?= sh4

# opkg control default values
VERSION_${P} ?= ${PV}-${PR}
DESCRIPTION_${P} ?= ${P}
MAINTAINER_${P} ?= Ar-P team
SECTION_${P} ?= base
PRIORITY_${P} ?= optional
LICENSE_${P} ?= unknown
HOMEPAGE_${P} ?= unknown

# build dependencies
DEPENDS_${P} += $(TARGET_${P}).version_${PV}-${PR}
DEPENDS_${P} += $(addprefix $(DEPDIR)/,$(BDEPENDS_${P}))

ifdef MAKE_VERBOSE
# pedantic dependecny check
$(foreach dep, $(value BDEPENDS_${P}), \
	$(if $(call undefined,$(patsubst $$(%),%,$(dep))), \
		$(warning undefined $(dep) in BDEPENDS_${P}) \
	) \
)
endif

# Set new variables and targets
PREPARE_${P} = (rm -rf $(WORK_${P}) || true) && mkdir -p $(WORK_${P})
INSTALL_${P} = true

$(TARGET_${P}).version_%:
	rm -f $(TARGET_${P}).version_*
	touch $@

$(TARGET_${P}).clean_prepare:
	rm -f $(TARGET_${P}).do_prepare

$(TARGET_${P}).clean_compile:
	rm -f $(TARGET_${P}).do_compile

$(TARGET_${P}).clean_package:
	rm -f $(TARGET_${P}).do_package

$(TARGET_${P}).clean: $(TARGET_${P}).clean_prepare
	rm -f $(TARGET_${P}).do_*

ifdef MAKE_VERBOSE
$(TARGET_${P}).help:
	@echo
	@echo ----------------------------------------------------------------------------
	@echo 'Hello my name is ${P}'
	@echo '$(subst ','\'',${DESCRIPTION})'
	@echo 'I am from $(dir ${SDIR})'
	@echo 'Bye!'
	@echo ----------------------------------------------------------------------------
endif

# default value comes from .config
# Either override it in *mk file or by passing to make like this: 'make target-foo RM_WORK_foo=n'
RM_WORK_${P} ?= $(CONFIG_RM_WORK)

# to add some build rules add prerequisites to this target
$(TARGET_${P}):
ifeq (${RM_WORK},y)
	rm -rf $(WORK_${P}) || true
endif
	test -f $@ && cp -a $@ $@.hold || true
	touch $@

ifdef MAKE_VERBOSE
# HACK
# touch deps with previous stamp
# should avoid dependent packages rebuild
$(TARGET_${P}).hold: $(TARGET_${P})
	touch $(TARGET_${P}).* -r $@
	touch $(TARGET_${P})   -r $@
.PHONY: $(TARGET_${P}).hold
endif

# add to list
all: $(TARGET_${P})

]]function

function[[ base_do_prepare
# place after variables and rule definitions
$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@
]]function

function[[ TARGET_base_do_config
# place after variables and rule definitions
$(TARGET_${P}).do_menuconfig $(TARGET_${P}).do_xconfig: \
$(TARGET_${P}).do_%: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && make $(MAKE_FLAGS_${P}) $*
	@echo
	`which colordiff || which diff` -u $(DIR_${P})/.config.old $(DIR_${P})/.config; \
	  test $$? -ne 2
	@echo ----------------------------------------------------------------------------
	@echo You might have to COPY
	@echo ${DIR}/.config
	@echo to
	@echo ${SDIR}/$(if ${CONFIG},${CONFIG},???.config)
	@echo to make changes permanent !!!
	@echo ----------------------------------------------------------------------------
]]function




# rollback
#############################################################################

# clean all dependent packages before do_compile
# do it if you suspect that future sysroot modifications influence your build
function[[ rollback
$(TARGET_${P}).do_compile: $(TARGET_${P}).do_rollback
$(TARGET_${P}).do_rollback: $(TARGET_${P}).do_prepare
#	Don't update makefile during submake runs
	$(MAKE) -o Makefile $(TARGET_${P}).clean
	touch $@
]]function




# ipk
#############################################################################

# ipk related constants
INHERIT_VARIABLES := NAME VERSION DESCRIPTION SECTION PRIORITY MAINTAINER LICENSE PACKAGE_ARCH HOMEPAGE RDEPENDS RREPLACES RCONFLICTS SRC_URI FILES
INHERIT_DEFINES := preinst postinst prerm postrm conffiles

opkg_cmd := echo -n "==> " && $(hostprefix)/bin/opkg -f $(prefix)/opkg.conf -o $(prefix)
# makes run only one instance of opkg at a time
opkg_script := $(call lock,$(opkg_cmd) $$@,$(prefix)/opkg.lock)
# opkg-safe must be created by host-opkg package
opkg := opkg-safe

# we have several dests, so dependencies are shared across them
host_ipkg_args   = -d hostroot
cross_ipkg_args  = -d crossroot
target_ipkg_args = -d targetroot

# If there is something strange with opkg run 'source opkg.env' and start hacking!
.PHONY: opkg.env
opkg.env:
	echo 'opkg-host()   { `which $(opkg)` $(host_ipkg_args) $$*; }'   >  $@
	echo 'opkg-cross()  { `which $(opkg)` $(cross_ipkg_args) $$*; }'  >> $@
	echo 'opkg-target() { `which $(opkg)` $(target_ipkg_args) $$*; }' >> $@

opkg-check-target opkg-check-cross opkg-check-host: \
opkg-check-%:
	set -e; \
	cat $($*prefix)/usr/lib/opkg/info/*.list |sort -u > db;  \
	find $($*prefix)/ -type d -printf '%p/\n' -o -print | sed 's,$(prefix)/*,/,' | sort > fs; \
	echo; \
	echo "files unknown to opkg:"; \
	comm --check-order -23 fs db; \
	echo; \
	echo "files missing:"; \
	comm --check-order -13 fs db; \
	true

define opkg-check-depends
	set -e; \
	$(opkg) list-installed |cut -f 1 -d ' ' |xargs $(opkg) depends \
	  |awk '/^\t/{print $$1}' |xargs $(opkg) whatprovides \
	  |awk ' \
	  /^What provides/{if(search) {print "==> Not found: " search; exit 1} else {search = $$3}} \
	  /^    /{search=""}'; \
	echo -e '==> depends OK'
endef
opkg-check-depends:
	$(opkg-check-depends)

help::
	@echo "run 'make opkg-check-{host|cross|target}' to list opkg disowned files"
	@echo "run 'make opkg-check-depends' to see unresolved dependencies"
.PHONY: opkg-check-target opkg-check-cross opkg-check-host opkg-check-depends

# format list separated with spaces to list separeated with commas
_ipk_control_list = $(subst $(space),$(comma),$(subst $(space)$(space),$(space),$(subst _,-,$(strip $1))))

# _ipk_write_control
# - 1: pkg that contains variables
# - 2: control file to write into
define _ipk_write_control_common
	$(eval export DESCRIPTION_$1)
	echo "Description: $${DESCRIPTION_$1}" >> $2
	echo 'Section: $(SECTION_$1)' >> $2
	echo 'Priority: $(PRIORITY_$1)' >> $2
	echo 'Maintainer: $(MAINTAINER_$1)' >> $2
	echo 'License: $(LICENSE_$1)' >> $2
	echo 'Homepage: $(HOMEPAGE_$1)' >> $2
	echo 'Source: $(SRC_URI_$1)' >> $2
endef
define _ipk_write_control
	echo 'Package: $(${P})' > $2
	echo 'Version: $(VERSION_$1)' >> $2
	echo 'Architecture: $(PACKAGE_ARCH_$1)' >> $2
	echo 'Depends: $(call _ipk_control_list,$(BDEPENDS_$1))' >> $2
	echo 'Replaces: $(call _ipk_control_list,$(BREPLACES_$1))' >> $2
	echo 'Conflicts: $(call _ipk_control_list,$(BCONFLICTS_$1))' >> $2
	echo 'Provides: $(call _ipk_control_list,$(BREMOVES_$1))' >> $2
	$(call _ipk_write_control_common,$1,$2)
endef

# adapt files for cross compiling
rewrite_libtool = \
	find $(ipkrootdir_${P}) -name "*.la" -type f -exec \
		perl -pi -e "s,^libdir=.*$$,libdir='$(targetprefix)/usr/lib'," {} \;
rewrite_dependency = \
	find $(ipkrootdir_${P}) -name "*.la" -type f -exec \
		perl -pi -e "s, /usr/lib, $(targetprefix)/usr/lib,g if /^dependency_libs/" {} \;
rewrite_pkgconfig = \
	find $(ipkrootdir_${P}) -name "*.pc" -type f -exec \
		perl -pi -e "s,^prefix=.*$$,prefix=$(targetprefix)/usr," {} \;
#FIXME: unpackaged 'cp'
rewrite_config = \
	cp $1 $(crossprefix)/bin/$(notdir $1) && \
	sed -e "s,^prefix=,prefix=$(targetprefix)," -i $(crossprefix)/bin/$(notdir $1)

function[[ ipk
# SYSROOT is one of host, cross, target
SYSROOT_${P} ?= $(error undefined SYSROOT_${P})
# Name of IPK that installs to SYSROOT
IPK_${P} ?= $(ipk${SYSROOT})/$(${P})_${VERSION}_${PACKAGE_ARCH}.ipk

ipkrootdir_${P} = ${WORK}/ipkrootdir
# for sysroot ipk we copy all files.
$(TARGET_${P}).do_ipk: $(TARGET_${P}).do_package
	rm -rf ${ipkrootdir}
	mkdir -p ${ipkrootdir}/CONTROL
ifeq (${SYSROOT},host)
	cp -ar $(PKDIR)/$(hostprefix)/* ${ipkrootdir}
endif
ifeq (${SYSROOT},cross)
	cp -ar $(PKDIR)/$(crossprefix)/* ${ipkrootdir}
endif
ifeq (${SYSROOT},target)
	cp -ar $(PKDIR)/* ${ipkrootdir}
	$(rewrite_libtool)
	$(rewrite_dependency)
endif

	$(call _ipk_write_control,${P},${ipkrootdir}/CONTROL/control)
	
	rm -f $(WORK_${P})/$(notdir $(IPK_${P}))
	ipkg-build -o root -g root ${ipkrootdir}/ ${WORK}

	mv $(WORK_${P})/$(notdir $(IPK_${P})) $(IPK_${P})
	touch $@

$(TARGET_${P}).clean_ipk:
	rm -rf $(TARGET_${P}).do_ipk

# finally install
$(TARGET_${P}).do_install: $(TARGET_${P}).do_ipk

#	Remove and save install commands for BREMOVES
	echo '#Saved list that undo bremoves' > $(TARGET_${P}).reinstall
	$(foreach pkg,${BREMOVES}, \
	  $(opkg) $(${SYSROOT}_ipkg_args) remove --force-depends $(pkg)  $(newline) \
	  cat $(DEPDIR)/$(pkg).do_install >> $(TARGET_${P}).reinstall    $(newline) \
	)

#	Save install command and run it
	echo '#Saved install command'                         >  $@
	echo '$(opkg) $(${SYSROOT}_ipkg_args) install ${IPK}' >> $@
	$(SHELL) $@

#	Track reverse dependency graph
	$(foreach bdep,$(BDEPENDS_${P}), \
	  echo '$(DEPDIR)/$(bdep).clean_install: $(TARGET_${P}).clean_install' > $(TARGET_${P}).bdeps && \
	) true

#	$(opkg-check-depends)
	touch $@

# Include tracked reverse dependencies
-include $(TARGET_${P}).bdeps
# Thanks to traked bdeps it is in fact recursive clean_install
$(TARGET_${P}).clean_install:
#	Remove my package
	$(if $(MAKE_DEBUG_IPK),,@) \
	if test -f $(TARGET_${P}).do_install; then \
	  $(opkg) $(${SYSROOT}_ipkg_args) remove --force-depends $(${P}); \
	fi

#	Reinstall BREMOVES packages
	$(if $(MAKE_DEBUG_IPK),,@) \
	if test -f $(TARGET_${P}).reinstall; then \
	  $(SHELL) $(TARGET_${P}).reinstall; \
	fi

#	$(opkg-check-depends)
	rm -f $(TARGET_${P}).do_install
	rm -f $(TARGET_${P}).reinstall
	rm -f $(TARGET_${P}).bdeps

$(TARGET_${P}): $(TARGET_${P}).do_install
$(TARGET_${P}).clean: $(TARGET_${P}).clean_install

]]function




# ipkbox
#############################################################################

help-functions::
	@echo
	@echo write_control
	@echo - 1: package name

write_control = $(call _ipkbox_write_control,$1,$(SPLITDIR_${P})/$1/CONTROL/control)

# _ipkbox_write_control
# - 1: pkg that contains variables
# - 2: control file to write into
define _ipkbox_write_control
	echo 'Package: $(NAME_$1)' > $2
	echo 'Version: $(VERSION_$1)' >> $2
	echo 'Architecture: $(PACKAGE_ARCH_$1)' >> $2
	echo 'Depends: $(call _ipk_control_list,$(RDEPENDS_$1))' >> $2
	echo 'Replaces: $(call _ipk_control_list,$(RREPLACES_$1))' >> $2
	echo 'Conflicts: $(call _ipk_control_list,$(RCONFLICTS_$1))' >> $2

	$(call _ipk_write_control_common,$1,$2)

	$(foreach file, preinst postinst prerm postrm conffiles,
		$(if $($(file)_$1),
			$(eval export $(file)_$1)
			$(info $($(file)_$1))
			printenv $(file)_$1 > $(SPLITDIR_${P})/$1/CONTROL/$(file)
		)
	)
	$(foreach file, preinst postinst prerm postrm,
		$(if $($(file)_$1),
			 chmod +x $(SPLITDIR_${P})/$(pkg)/CONTROL/$(file)
		)
	)
endef

define strip_libs
	find $(SPLITDIR_${P})/* -type f -regex '.*/lib/.*\.so\(\.[0-9]+\)*' \
		-exec echo strip {} \; \
		-exec $(target)-strip --strip-unneeded {} \;
endef
define remove_libs
	rm -f $(SPLITDIR_${P})/*/lib/*.{a,la,o}
	rm -f $(SPLITDIR_${P})/*/usr/lib/*.{a,la,o}
endef
define remove_pkgconfigs
	rm -rf $(SPLITDIR_${P})/*/usr/lib/pkgconfig
endef
define remove_includedir
	rm -rf $(SPLITDIR_${P})/*/usr/include
endef
define remove_docs
	rm -rf $(SPLITDIR_${P})/*/usr/share/doc
	rm -rf $(SPLITDIR_${P})/*/usr/share/man
	rm -rf $(SPLITDIR_${P})/*/usr/share/info
	rm -rf $(SPLITDIR_${P})/*/usr/share/locale
	rm -rf $(SPLITDIR_${P})/*/usr/share/gtk-doc
endef

# - 1: ${P}
define _ipkbox_do_split
	$(foreach pkg, $(PACKAGES_$1),
		install -d $(SPLITDIR_${P})/$(pkg)/CONTROL/
		$(call write_control,$(pkg))
		$(eval export FILES_$(pkg))
	)
	python $(buildprefix)/split.py $(PKDIR) $(SPLITDIR_${P}) $(PACKAGES_$1)
endef

function[[ ipkbox

SPLITDIR_${P} = $(WORK_${P})/split
PACKAGES_${P} ?= $(patsubst host_%,%,$(patsubst cross_%,%,$(patsubst target_%,%, ${P} )))
FILES_${P} ?= /

$(TARGET_${P}).set_inherit_vars: $(TARGET_${P}).do_package
	$(info ==> $(notdir $@)) \
	$(foreach pkg, $(PACKAGES_${P}), \
		$(foreach var, $(INHERIT_VARIABLES), \
			$(if $(call undefined,$(var)_$(pkg)), \
				$(call eval_assign,$(var)_$(pkg),$(var)_${P}) \
			) \
		) \
		$(if $(NAME_$(pkg)),, \
			$(eval NAME_$(pkg) := $(subst _,-,$(pkg)) ) \
		) \
		$(foreach var, $(INHERIT_DEFINES), \
			$(if $(call undefined,$(var)_$(pkg)), \
				$(call eval_define,$(var)_$(pkg),$(var)_${P}) \
			) \
		) \
	)

.PHONY: $(TARGET_${P}).set_inherit_vars

$(TARGET_${P}).do_split: $(TARGET_${P}).do_package | $(TARGET_${P}).set_inherit_vars
	rm -rf $(SPLITDIR_${P})/*
	mkdir -p $(SPLITDIR_${P})

	$(call _ipkbox_do_split,${P})

	touch $@

$(TARGET_${P}).do_ipkbox: $(TARGET_${P}).do_split
	$(remove_docs)
	$(remove_libs)
	$(remove_pkgconfigs)
	$(strip_libs)

	set -e; \
	for pkg in `ls $(SPLITDIR_${P})`; do \
		echo "building package $${pkg} ..."; \
		pkgn=`cat $(SPLITDIR_${P})/$${pkg}/CONTROL/control |sed -n '/^Package:/ s/Package: //p'`; \
		echo ${P} > $(ipkorigin)/$${pkgn}.origin; \
		ipkg-build -o root -g root $(SPLITDIR_${P})/$${pkg} $(ipkbox); \
	done

	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_ipkbox

]]function




# git
#############################################################################

# git staff related constants
# you need first 'cd' to interesting directory
git_log_srcrev := git log -1 --format=%H HEAD -- .
git_log_version := echo `git rev-list --count HEAD -- .`-`git log -1 --format=%h HEAD -- .`

help::
	@echo run \'make all-update\' if you want to check all git/svn packages for updates
.PHONY: all-update

function[[ git
# place after rule definitions
# now you have GIT_VERSION_${P} variable

# Check requirements
GIT_DIR_${P} ?= $(error undefined GIT_DIR_${P})
GIT_DIR_${P} := $(strip $(GIT_DIR_${P}))

# Set file where we store srcrev
SRCREV_${P} = $(TARGET_${P}).do_srcrev

# add dependencies:
# you need do_srcrev at prepare time, so if git is updated all rebuilds.
$(TARGET_${P}).do_prepare: $(SRCREV_${P})
# I assume you need GIT_VERSION variable at packaging time
$(TARGET_${P}).do_package: $(TARGET_${P}).do_git_version

# In case more than one package use sources from same git
ifdef UPDATE_${P}
UPDATE_SAFE_${P} := $(call lock, $(UPDATE_${P}), $(GIT_DIR_${P}).lock)
else
UPDATE_SAFE_${P} :=
endif
# initial srcrev value
$(SRCREV_${P}): $(GIT_DIR_${P})
	$(UPDATE_SAFE_${P})
	cd $(GIT_DIR_${P}) && $(git_log_srcrev) > ${SRCREV}

# update stored srcrev if it has changed
$(TARGET_${P}).do_update: $(GIT_DIR_${P})
	@echo && echo "==> checking ${SRCREV}" && echo
	$(UPDATE_${P})
	cd $(GIT_DIR_${P}) && $(git_log_srcrev) > ${SRCREV}_tmp

	(test -f ${SRCREV} && test "`cat ${SRCREV}_tmp`" == "`cat ${SRCREV}`") \
	|| (cp ${SRCREV}_tmp ${SRCREV} && touch ${SRCREV} && \
	    echo && echo "==> updated ${SRCREV}" && echo)
	
	rm -f ${SRCREV}_tmp

VERSION_${P} = ${PV}${GIT_VERSION}-${PR}

# GIT_VERSION_${P} is dynamic variable
# We use dynamic variables pattern,
# I suggest to use such Makefile 'hack' everytime you deal with dynamic variables

# end user target is do_git_version, specify it as prerequisite if you access dynamic variable
$(TARGET_${P}).do_git_version: $(TARGET_${P}).write_git_version | $(TARGET_${P}).include_git_version
	touch $@

# inlude is evaluated every time make runs, beacause it is phony target and specified as oder-only prerequisite
$(TARGET_${P}).include_git_version: $(TARGET_${P}).write_git_version
	@echo "==> include $<"
	$(eval include $<)

.PHONY: $(TARGET_${P}).include_git_version

# Here we specify the main code of generating dynamic variables
# output file will be included by make at run time
$(TARGET_${P}).write_git_version: ${SRCREV}
	echo -n "GIT_VERSION_${P} := " > $@
	cd $(GIT_DIR_${P}) && $(git_log_version) >> $@

# add to list
all-update: $(TARGET_${P}).do_update

]]function



# svn
#############################################################################

# very similar with git
# TODO: some common vcs function

# svn staff related constants
# you need first 'cd' to interesting directory
svn_log_srcrev := svn info | awk '/Revision:/ { print $$2 }'
svn_log_version := svn info | awk '/Revision:/ { print $$2 }'

function[[ svn
# place after rule definitions
# now you have SVN_VERSION_${P} variable

# Check requirements
SVN_DIR_${P} ?= $(error undefined SVN_DIR_${P})

# Set file where we store srcrev
SRCREV_${P} = $(TARGET_${P}).do_srcrev

# add dependencies:
# you need do_srcrev at prepare time, so if svn is updated all rebuilds.
$(TARGET_${P}).do_prepare: $(SRCREV_${P})
# I assume you need SVN_VERSION variable at packaging time
$(TARGET_${P}).do_package: $(TARGET_${P}).do_svn_version

# initial srcrev value
$(SRCREV_${P}): $(SVN_DIR_${P})
	$(UPDATE_${P})
	cd $(SVN_DIR_${P}) && $(svn_log_srcrev) > ${SRCREV}

# update stored srcrev if it has changed
$(TARGET_${P}).do_update: $(SVN_DIR_${P})
	@echo && echo "==> checking ${SRCREV}" && echo
	$(UPDATE_${P})
	cd $(SVN_DIR_${P}) && $(svn_log_srcrev) > ${SRCREV}_tmp

	(test -f ${SRCREV} && test "`cat ${SRCREV}_tmp`" == "`cat ${SRCREV}`") \
	|| (cp ${SRCREV}_tmp ${SRCREV} && touch ${SRCREV} && \
	    echo && echo "==> updated ${SRCREV}" && echo)
	
	rm -f ${SRCREV}_tmp

VERSION_${P} = ${PV}${SVN_VERSION}-${PR}

# SVN_VERSION_${P} is dynamic variable
# We use dynamic variables pattern,
# I suggest to use such Makefile 'hack' everytime you deal with dynamic variables

# end user target is do_svn_version, specify it as prerequisite if you access dynamic variable
$(TARGET_${P}).do_svn_version: $(TARGET_${P}).write_svn_version | $(TARGET_${P}).include_svn_version
	touch $@

# inlude is evaluated every time make runs, beacause it is phony target and specified as oder-only prerequisite
$(TARGET_${P}).include_svn_version: $(TARGET_${P}).write_svn_version
	@echo "==> include $<"
	$(eval include $<)

.PHONY: $(TARGET_${P}).include_svn_version

# Here we specify the main code of generating dynamic variables
# output file will be included by make at run time
$(TARGET_${P}).write_svn_version: $(SVN_DIR_${P})
	echo -n "SVN_VERSION_${P} := " > $@
	cd $(SVN_DIR_${P}) && $(svn_log_version) >> $@

# add to list
all-update: $(TARGET_${P}).do_update

]]function
