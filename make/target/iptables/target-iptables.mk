#
# AR-P buildsystem smart Makefile
#
package[[ target_iptables

BDEPENDS_${P} = $(target_linux_kernel)

PR_${P} = 1

PV_${P} = 1.4.10-15
${P}_SPEC = stm-$(${P}).spec
${P}_SPEC_PATCH =
${P}_PATCHES =
${P}_SRCRPM = $(archivedir)/$(STLINUX)-$(${P})-$(PV_${P}).src.rpm

call[[ base ]]
call[[ base_rpm ]]

DO_PACKAGE_${P} = chmod 755 $(PKDIR)/etc/init.d/iptables

call[[ rpm ]]
call[[ ipk ]]

RDEPENDS_${P} = linux-kernel libc6
FILES_${P} = /etc/* /usr/bin/* /usr/lib/*.so* /usr/libexec/* /usr/sbin/*
DESCRIPTION_${P} = netfilter is a set of hooks inside the Linux kernel that allows kernel \
modules to register callback functions with the network stack. A registered callback function \
is then called back for every packet that traverses the respective hook within the network stack

define postinst_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ iptables start 20 2 3 4 5 . stop 20 6 .
endef

define prerm_${P}
#!/bin/sh
update-rc.d -r $$OPKG_OFFLINE_ROOT/ iptables remove
endef

call[[ ipkbox ]]

]]package
