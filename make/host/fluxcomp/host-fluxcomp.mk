#
# HOST MAKE
#
package[[ host_fluxcomp

BDEPENDS_${P} = $(target_glibc)

PV_${P} = git
PR_${P} = 1

call[[ base ]]

rule[[
  nothing:git://github.com/Distrotech/flux.git
]]rule

call[[ git ]]

call[[ base_do_prepare ]]

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		./autogen.sh &&\
		./configure \
			--prefix=$(hostprefix) && \
		$(run_make) all PREFIX=$((hostprefix) &&  \
		$(run_make) install PREFIX=$((hostprefix)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

]]package
