# chain
#############################################################################

# Takes care about dependency chains
# In oder to use this you:
# 1) must specify BDEPENDS
# 2) must link ${TARGET}.do_depends to ${TARGET}
# Result will be the following for build chain
#   all ${BDEPENDS} <- ${TARGET}.do_depends <- YOUR_TARGETS_HERE <- ${TARGET} <- other $(TARGET_*).do_depends
# And for clean chain
#   $(TARGET_*).clean <- ${TARGET}.clean_childs <- YOUR_CLEANUP_HERE <- ${TARGET}.clean <- all ${BDEPENDS}.clean_childs
#
# During using build system you may invoke
# 1) make ${TARGET}
# 2) make ${TARGET}.clean
# And kind of hack, that makes ${TARGET} but not result in recursive rebuild later
# 3) make ${TARGET}.hold


function[[ chain

# Make sure that we have corresponding header
${P} ?= $(error undefined ${P})
TARGET_${P} ?= $(error undefined TARGET_${P})

ifdef MAKE_VERBOSE
# pedantic dependecny check
$(foreach dep, $(value BDEPENDS_${P}), \
	$(if $(call undefined,$(patsubst $$(%),%,$(dep))), \
		$(warning undefined $(dep) in BDEPENDS_${P}) \
	) \
)
endif

# set working directory
WORK_${P} := $(workprefix)/${P}

${TARGET}.do_depends: $(addprefix $(DEPDIR)/,${BDEPENDS})
#	Add target to clean chain when start build
	echo -n > ${TARGET}.bdep
	$(foreach pkg,${BDEPENDS}, \
	  echo '$(DEPDIR)/$(pkg).clean_childs: ${TARGET}.clean' >> ${TARGET}.bdep && \
	) true
	touch $@


# default value comes from .config
# Either override it in *mk file or by make argument: 'make target-foo RM_WORK_foo=n'
RM_WORK_${P} ?= $(CONFIG_RM_WORK)

# Remove work after we are done with this package
${TARGET}:
ifeq (${RM_WORK},y)
	rm -rf ${WORK} || true
endif
	test -f $@ && cp -a $@ $@.hold || true
	touch $@
	@echo "==> Finished ${P}"
	@echo

ifdef MAKE_VERBOSE
# HACK
# touch deps with previous stamp
# should avoid dependent packages rebuild
${TARGET}.hold: ${TARGET}
	touch ${TARGET}.* -r $@
	touch ${TARGET}   -r $@
.PHONY: ${TARGET}.hold
endif

# add to list
all: ${TARGET}


# saved reverse dependecnies
-include ${TARGET}.bdep
${TARGET}.clean_childs:
	@echo "==> clean ${P}"

${TARGET}.clean:
	rm -f ${TARGET}.bdep ${TARGET}.do_depends

]]function
