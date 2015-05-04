#
# AR-P buildsystem smart Makefile
#
package[[ target_libeplayer3

BDEPENDS_${P} = $(target_glibc) $(target_gcc_lib) $(target_driver) $(target_libass) $(target_ffmpeg)

PR_${P} = $(PR_tdt_tools).1

DESCRIPTION_${P} = libeplayer3
CONFIG_FLAGS_${P} += --prefix=/usr

PACKAGES_${P} = libeplayer3 \
		eplayer3 \
		eplayer3_meta


RDEPENDS_libeplayer3 = kernel_module_player2 kernel_module_stgfb ffmpeg libass
FILES_libeplayer3 =/usr/lib/libeplayer3.s*
RDEPENDS_eplayer3_meta = libeplayer3
FILES_eplayer3_meta = /usr/bin/meta
RDEPENDS_eplayer3 = libeplayer3
FILES_eplayer3 =/usr/bin/eplayer3



call[[ base_tdt_tools ]]

call[[ TARGET_tdt_tools ]]

]]package
