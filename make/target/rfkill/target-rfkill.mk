#
# AR-P buildsystem smart Makefile
#
package[[ target_rfkill

BDEPENDS_${P} = $(target_glibc)

PV_${P} = git
PR_${P} = 2

call[[ base ]]

rule[[
  git://github.com/jprvita/rfkill.git
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(run_make) $(MAKE_ARGS)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

DESCRIPTION_${P} = rfkill is a small tool to query the state of the rfkill switches, buttons and subsystem interfaces
RDEPENDS_${P} = libc6
FILES_${P} = /usr/sbin/*

call[[ ipkbox ]]

]]package
