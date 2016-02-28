#
# Host programs vital for future build
#
package[[ meta_host

BDEPENDS_${P} = \
  $(host_autoconf) $(host_automake) $(host_autotools) $(host_pkg_config) $(host_libtool) \
  $(host_module_init_tools) $(host_mtd_utils) $(host_lndir) $(host_ipkg_utils) $(host_opkg)

call[[ chain ]]

# Note this is kind of ${TARGET}.hold by default. Use this pattern every time you want weak dependency

# If some of host programs is updated
# we will not rebuild all dependent packages by default
${TARGET}: | ${TARGET}.do_depends

# If you decided to clean it, or any package in its ${BDEPENDS}
# be ready that it will wipe whole toolchain
${TARGET}.clean: ${TARGET}.clean_childs

]]package