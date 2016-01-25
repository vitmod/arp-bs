#
# AR-P buildsystem smart Makefile
#
package[[ target_usbutils

BDEPENDS_${P} = $(target_filesystem) $(target_libusb_compat)

PR_${P} = 1

PV_${P} = 0.86-11
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]
call[[ ipkbox ]]

]]package
