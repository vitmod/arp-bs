#
# AR-P buildsystem smart Makefile
#
package[[ target_image

BDEPENDS_${P} = $(target_rootfs)

PV_${P} = 0.1
PR_${P} = 1

call[[ base ]]

$(TARGET_${P}).do_image: $(TARGET_${P}).do_depends
	@echo "Create image ..."
ifeq ($(CONFIG_SPARK)$(CONFIG_SPARK7162),y)
	mkdir -p $(prefix)/flash
	cp ${SDIR}/spark.sh $(prefix)/flash
	cd $(prefix)/flash && ./spark.sh $(prefix) \
	OpenAR-P_$(KERNEL_RELEASE)_$(TARGET)_$(if $(CONFIG_EPLAYER3),epl3,gst)_py$(PYTHON_VERSION)\
	_git`git rev-list --count HEAD`_`date +%d-%m-%y`
endif

	@echo
	@echo '==> FINISH'
	@echo '==> image is in $(prefix)/flash/out'
	@echo
	touch $@

$(TARGET_${P}): $(TARGET_${P}).do_image

]]package
