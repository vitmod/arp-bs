#
# AR-P buildsystem smart Makefile
#
package[[ target_mpc

BDEPENDS_${P} = $(target_mpfr)

PR_${P} = 1

PV_${P} = 1.0.1-5
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

DESCRIPTION_${P} = mpc is a client for MPD, the Music Player Daemon. mpc connects to a MPD \
and controls it according to commands and arguments passed to it. If no command is given, \
the current status is printed (same as 'mpc status').

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

]]package
