#
# AR-P buildsystem smart Makefile
#
package[[ target_emulators

BDEPENDS_${P} = $(target_filesystem)

PV_${P} = git
PR_${P} = 2

call[[ base ]]

rule[[
  git://github.com/schpuntik/cams.git
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_package: $(TARGET_${P}).do_prepare
	$(PKDIR_clean)
	touch $@

# we don't have anything to split
PACKAGES_${P} =
call[[ ipkbox ]]

# DIR is already a tree for ipkbox
$(TARGET_${P}).do_split_post: $(TARGET_${P}).do_split
	cp -ar ${DIR}/* ${SPLITDIR}
	touch $@

$(TARGET_${P}).do_ipkbox: $(TARGET_${P}).do_split_post

]]package
