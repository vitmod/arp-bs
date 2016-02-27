#
# AR-P buildsystem smart Makefile
#
package[[ target_mpfr

BDEPENDS_${P} = $(target_gmp)

PR_${P} = 1

PV_${P} = 3.1.2-10
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

DESCRIPTION_${P} = The GNU MPFR library (or MPFR for short) is free; this means that everyone is \
free to use it and free to redistribute it on a free basis. The library is not in the public domain; \
it is copyrighted and there are restrictions on its distribution, but these restrictions are designed \
to permit everything that a good cooperating citizen would want to do. What is not allowed is to try to \
prevent others from further sharing any version of this library that they might get from you.

call[[ base ]]
call[[ base_rpm ]]
call[[ rpm ]]
call[[ ipk ]]

]]package
