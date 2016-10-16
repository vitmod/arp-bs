#
# AR-P buildsystem smart Makefile
#
package[[ target_libdvbsipp

BDEPENDS_${P} = $(target_glibc) $(target_gcc_lib)

PV_${P} = 0.3.8
PR_${P} = 1

PN_${P} = libdvbsi++
DESCRIPTION_${P} = libdvbsi++ is a open source C++ library for parsing DVB Service Information and MPEG-2 Program Specific Information.

call[[ base ]]

rule[[
  git://git.opendreambox.org/git/obi/libdvbsi++.git;b=master;r=c4d4597fb8bf77d1fd4b122438c71a762080a245
  patch:file://${PN}-${PV}.patch
]]rule

call[[ base_do_prepare ]]

#CXXFLAGS="-I $(targetprefix)/usr/include/c++/4.7.3" \

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./autogen.sh && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
		&& \
		$(run_make) all
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

NAME_${P} = libdvbsi++1
RDEPENDS_${P} = libgcc1 libstdc++6
FILES_${P} = /usr/lib/libdvbsi++.so.*

call[[ provides_so ]]
call[[ ipkbox ]]

]]package
