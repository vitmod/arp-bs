# print '+' before each executed command
# SHELL := $(SHELL) -x

# gnu make strings magic
empty :=
define newline


endef
space := $(empty) $(empty)
comma := ,

# def
# - 1: multiline variable name
# - 2: multiline variable value
def = define $1 $(newline)$2$(newline)endef

# global consts
target_arch := sh4
target := sh4-linux

# detect host system 32 or 64 bit
host_arch := $(shell which arch > /dev/null 2>&1 && arch || uname -m)
ifeq ($(host_arch),i686)
host := $(host_arch)-pc-linux-gnu
else
host := $(host_arch)-unknown-linux-gnu
endif
build := $(host)

# selected target box
ifdef CONFIG_SPARK
TARGET := spark
endif
ifdef CONFIG_SPARK7162
TARGET := spark7162
endif
ifdef CONFIG_HL101
TARGET := hl101
endif
box_arch := $(TARGET)

# directories
archivedir = $(HOME)/Archive

# root dir hack
buildprefix := $(shell pwd)
tdtdir := $(patsubst %/cvs/cdk,%,$(buildprefix))

# dependency control dir
DEPDIR := $(buildprefix)/.deps
$(shell mkdir -p $(DEPDIR))
VPATH := $(DEPDIR)

# build root directories
prefix := $(tdtdir)/tufsbox
# host
hostprefix := $(prefix)/host
ipkhost := $(prefix)/ipkhost
# cross
devkitprefix := $(prefix)/devkit
crossprefix := $(devkitprefix)/sh4
targetsh4prefix := $(crossprefix)/target-sh4
ipkcross := $(prefix)/ipkcross
# target
targetprefix := $(prefix)/target
targetboxprefix := $(prefix)/target-$(TARGET)
ipktarget := $(prefix)/ipktarget
# kernel sources dir
kernelprefix := $(devkitprefix)/sources/kernel

ipkbox := $(prefix)/ipkbox

# strange directories
configprefix := $(hostprefix)/config
appsdir := $(tdtdir)/cvs/apps
driverdir := $(tdtdir)/cvs/driver

# build temporary directories
specsprefix := $(prefix)/SPECS
sourcesprefix := $(prefix)/SOURCES
workprefix := $(prefix)/work
ipkgbuilddir := $(prefix)/ipkgbuild
ipkverify := $(prefix)/ipkverify
PKDIR := $(prefix)/packagingtmpdir


# FIXME:
export CFLAGS = -g -O2
export CXXFLAGS = -g -O2

# Kernel configuration

ifdef CONFIG_KERNEL_0207
KERNEL_VERSION := 2.6.32.28_stm24_0207
endif

ifdef CONFIG_KERNEL_0209
KERNEL_VERSION := 2.6.32.46_stm24_0209
endif

ifdef CONFIG_KERNEL_0210
KERNEL_VERSION := 2.6.32.57_stm24_0210
endif

ifdef CONFIG_KERNEL_0211
KERNEL_VERSION := 2.6.32.59_stm24_0211
endif

ifdef CONFIG_KERNEL_0212
KERNEL_VERSION := 2.6.32.61_stm24_0212
endif

KERNEL_VERSION_SPLITED := $(subst _, ,$(KERNEL_VERSION))
KERNEL_UPSTREAM := $(word 1,$(KERNEL_VERSION_SPLITED))
KERNEL_STM := $(word 2,$(KERNEL_VERSION_SPLITED))
KERNEL_LABEL := $(word 3,$(KERNEL_VERSION_SPLITED))
KERNEL_RELEASE := $(subst ^0,,^$(KERNEL_LABEL))
# TODO: add KERNEL_DIR 

STLINUX := stlinux24
#? TODO: STM_RELOCATE := /opt/STM/STLinux-2.4

# PATH is exported automatically
PATH := $(crossprefix)/bin:$(hostprefix)/bin:$(PATH)
ifdef ENABLE_CCACHE
PATH := $(hostprefix)/ccache-bin:$(PATH)
endif


# TODO: review these variables
DEPMOD = $(hostprefix)/bin/depmod
SOCKSIFY=
CMD_CVS=$(SOCKSIFY) $(shell which cvs)
WGET=$(SOCKSIFY) wget -P

INSTALL := install
INSTALL_DIR=$(INSTALL) -d
INSTALL_BIN=$(INSTALL) -m 755
INSTALL_FILE=$(INSTALL) -m 644
LN_SF=$(shell which ln) -sf
CP_D=$(shell which cp) -d
CP_P=$(shell which cp) -p
CP_RD=$(shell which cp) -rd
SED=$(shell which sed)

MAKE_PATH := $(hostprefix)/bin:$(PATH)

# rpm helper-"functions":
PKG_CONFIG_PATH = $(targetprefix)/usr/lib/pkgconfig
REWRITE_LIBDIR = sed -i "s,^libdir=.*,libdir='$(targetprefix)/usr/lib'," $(targetprefix)/usr/lib
REWRITE_LIBDEP = sed -i -e "s,\(^dependency_libs='\| \|-L\|^dependency_libs='\)/usr/lib,\$(targetprefix)/usr/lib," $(targetprefix)/usr/lib

BUILDENV := \
	source $(buildprefix)/build.env &&

EXPORT_BUILDENV := \
	export PATH=$(PATH) && \
	export CC=$(target)-gcc && \
	export CXX=$(target)-g++ && \
	export LD=$(target)-ld && \
	export NM=$(target)-nm && \
	export AR=$(target)-ar && \
	export AS=$(target)-as && \
	export RANLIB=$(target)-ranlib && \
	export STRIP=$(target)-strip && \
	export OBJCOPY=$(target)-objcopy && \
	export OBJDUMP=$(target)-objdump && \
	export LN_S="ln -s" && \
	export CFLAGS="$(TARGET_CFLAGS)" && \
	export CXXFLAGS="$(TARGET_CFLAGS)" && \
	export LDFLAGS="$(TARGET_LDFLAGS) -Wl,-rpath-link,$(PKDIR)/usr/lib" && \
	export PKG_CONFIG_SYSROOT_DIR="$(targetprefix)" && \
	export PKG_CONFIG_PATH="$(targetprefix)/usr/lib/pkgconfig" && \
	export PKG_CONFIG_LIBDIR="$(targetprefix)/usr/lib/pkgconfig"

build.env:
	echo '$(EXPORT_BUILDENV)' |sed 's/&&/\n/g' |sed 's/^ //' > $@

MAKE_OPTS := \
	CC=$(target)-gcc \
	CXX=$(target)-g++ \
	LD=$(target)-ld \
	NM=$(target)-nm \
	AR=$(target)-ar \
	AS=$(target)-as \
	RANLIB=$(target)-ranlib \
	STRIP=$(target)-strip \
	OBJCOPY=$(target)-objcopy \
	OBJDUMP=$(target)-objdump \
	LN_S="ln -s" \
	ARCH=sh \
	CROSS_COMPILE=$(target)-

MAKE_ARGS := \
	CC=$(target)-gcc \
	CXX=$(target)-g++ \
	LD=$(target)-ld \
	NM=$(target)-nm \
	AR=$(target)-ar \
	AS=$(target)-as \
	RANLIB=$(target)-ranlib \
	STRIP=$(target)-strip \
	OBJCOPY=$(target)-objcopy \
	OBJDUMP=$(target)-objdump \
	LN_S="ln -s"

PLATFORM_CPPFLAGS := $(CPPFLAGS) -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include -I$(appsdir)/misc/tools

ifdef CONFIG_SPARK
PLATFORM_CPPFLAGS += -DPLATFORM_SPARK
endif

ifdef CONFIG_SPARK7162
PLATFORM_CPPFLAGS += -DPLATFORM_SPARK7162
endif

ifdef CONFIG_HL101
PLATFORM_CPPFLAGS += -DPLATFORM_HL101
endif

PLATFORM_CPPFLAGS := CPPFLAGS="$(PLATFORM_CPPFLAGS)"

CONFIGURE_OPTS = \
	--build=$(build) \
	--host=$(target) \
	--prefix=$(targetprefix)/usr \
	--with-driver=$(driverdir) \
	--with-dvbincludes=$(driverdir)/include \
	--with-target=cdk

ifdef ENABLE_CCACHE
CONFIGURE_OPTS += --enable-ccache 
endif

ifdef MAINTAINER_MODE
CONFIGURE_OPTS += --enable-maintainer-mode
endif

CONFIGURE = \
	./autogen.sh && \
	CC=$(target)-gcc \
	CXX=$(target)-g++ \
	CFLAGS="-Wall $(TARGET_CFLAGS)" \
	CXXFLAGS="-Wall $(TARGET_CXXFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	./configure $(CONFIGURE_OPTS)

# FIXME
start_build = $(error obsolete)

# TODO: move it somewhere
# all helpers
PKDIR_clean = rm -rf $(PKDIR)/* && mkdir -p $(PKDIR)

# rpm helpers
rpm_macros := --macros /usr/lib/rpm/macros:$(configprefix)/rpm/hosts/$(build):$(configprefix)/rpm/targets/$(target):$(configprefix)/rpm/common:$(buildprefix)/localmacros
# --dbpath $(prefix)/rpmdb
rpm_src_install := rpm $(rpm_macros) --ignorearch --nosignature -Uhv
#rpm_build := rpmbuild $(rpm_macros) -bb -v --clean --target=$(target)
rpm_build := rpmbuild $(rpm_macros) -bi -v --nodeps --target=$(target)
rpm_install := rpm $(rpm_macros)  --ignorearch --nodeps -Uhv

# python helpers
python_build = \
	CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
	PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
	$(crossprefix)/bin/python ./setup.py build

#	$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build

python_install = \
	CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
	PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
	$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
