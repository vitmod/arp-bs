#
# AR-P buildsystem smart Makefile
#
package[[ target_openssl

BDEPENDS_${P} = $(target_gcc_lib)

PR_${P} = 2

PV_${P} = 1.0.1h-31
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

PACKAGES_${P} =  libcrypto1 libssl1
DESCRIPTION_${P} = Secure Socket Layer (SSL) binary and related cryptographic tools.

FILES_libcrypto1 = /usr/lib/libcrypto.s*

RDEPENDS_libssl1 = libcrypto1
FILES_libssl1 = /usr/lib/libssl.s*

call[[ ipkbox ]]

]]package
