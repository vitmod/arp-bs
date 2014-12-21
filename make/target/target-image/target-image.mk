#
# AR-P buildsystem smart Makefile
#
package[[ target_image

DEPENDS_${P} = $(target_rootfs)

PV_${P} = 0.1
PR_${P} = 1

call[[ base ]]

$(TARGET_${P}).do_image: $(DEPENDS_${P})
	@echo "Create image ..."
ifeq ($(CONFIG_SPARK)$(CONFIG_SPARK7162),y)
	mkdir -p $(prefix)/flash
	cp ${SDIR}/spark.sh $(prefix)/flash
	cd $(prefix)/flash && ./spark.sh $(prefix) \
	OpenAR-P_$(KERNEL_RELEASE)_$(TARGET)_$(if $(CONFIG_EPLAYER3),epl3,gst)_py$(PYTHON_VERSION)\
	_git`git rev-list --count HEAD`_`date +%d-%m-%y`
endif
	touch $@
	@echo
	@echo '==> FINISH'
	@echo

$(TARGET_${P}): $(TARGET_${P}).do_image

]]package
