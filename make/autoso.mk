function[[ provides_so

$(TARGET_${P}).write_provides: $(TARGET_${P}).do_split
	set -e; \
	echo > $@; \
	for pkg in `ls ${SPLITDIR}`; \
	do \
		cd ${SPLITDIR}/$$pkg; \
		for s in `find /lib /usr/lib -maxdepth 1 -type l -name '*.so.*'`; \
		do \
			sn=`echo $$s |sed -e 's,.*lib/,,' -e 's,\.so\.,,'; \
			echo "PROVIDES_$$p += $$sn" >> $@; \
		done \
	done \
	true

$(TARGET_${P}).include_provides: $(TARGET_${P}).write_provides
	$(info "==> include $<")
	$(eval include $<)

$(TARGET_${P}).do_controls: | $(TARGET_${P}).include_provides

]]function
