#
# AR-P buildsystem smart Makefile
#
package[[ target_ffmpeg

BDEPENDS_${P} = $(target_glibc) $(target_libbluray) $(target_rtmpdump)

PV_${P} = ${PV_MOJ}.${PV_MIN}
PV_MOJ_${P} = 2.6
PV_MIN_${P} = 3

PR_${P} = 2

DESCRIPTION_${P} = ffmpeg

call[[ base ]]

rule[[
  extract:http://www.${PN}.org/releases/${PN}-${PV}.tar.gz
  patch:file://${PN}-${PV_MOJ}.patch
  patch:file://${PN}-hds-${PV_MOJ}.patch
  patch:file://${PN}-aac-${PV_MOJ}.patch
]]rule

FFMPEG_FLAGS_${P} = \
		--enable-librtmp \
		--enable-protocol=librtmp \
		--enable-protocol=librtmpe \
		--enable-protocol=librtmps \
		--enable-protocol=librtmpt \
		--enable-protocol=librtmpte

CONFIG_FLAGS_${P} = \
		--disable-ffserver \
		--disable-ffplay \
		--disable-ffprobe
CONFIG_FLAGS_${P} += \
		--disable-doc \
		--disable-htmlpages \
		--disable-manpages \
		--disable-podpages \
		--disable-txtpages
CONFIG_FLAGS_${P} += \
		--disable-asm \
		--disable-altivec \
		--disable-amd3dnow \
		--disable-amd3dnowext \
		--disable-mmx \
		--disable-mmxext \
		--disable-sse \
		--disable-sse2 \
		--disable-sse3 \
		--disable-ssse3 \
		--disable-sse4 \
		--disable-sse42 \
		--disable-avx \
		--disable-fma4 \
		--disable-armv5te \
		--disable-armv6 \
		--disable-armv6t2 \
		--disable-vfp \
		--disable-neon \
		--disable-inline-asm \
		--disable-yasm \
		--disable-mips32r2 \
		--disable-mipsdspr1 \
		--disable-mipsdspr2 \
		--disable-mipsfpu \
		--disable-fast-unaligned \
		--disable-dxva2 \
		--disable-vaapi \
		--disable-vdpau
CONFIG_FLAGS_${P} += \
		--disable-muxers \
		--enable-muxer=flac \
		--enable-muxer=mp3 \
		--enable-muxer=h261 \
		--enable-muxer=h263 \
		--enable-muxer=h264 \
		--enable-muxer=image2 \
		--enable-muxer=mpeg1video \
		--enable-muxer=mpeg2video \
		--enable-muxer=mpegts \
		--enable-muxer=ogg
CONFIG_FLAGS_${P} += \
		--disable-parsers \
		--enable-parser=aac \
		--enable-parser=aac_latm \
		--enable-parser=ac3 \
		--enable-parser=dca \
		--enable-parser=dvbsub \
		--enable-parser=dvdsub \
		--enable-parser=flac \
		--enable-parser=h264 \
		--enable-parser=mjpeg \
		--enable-parser=mpeg4video \
		--enable-parser=mpegvideo \
		--enable-parser=mpegaudio \
		--enable-parser=vc1 \
		--enable-parser=vorbis
CONFIG_FLAGS_${P} += \
		--disable-encoders \
		--enable-encoder=aac \
		--enable-encoder=h261 \
		--enable-encoder=h263 \
		--enable-encoder=h263p \
		--enable-encoder=ljpeg \
		--enable-encoder=mjpeg \
		--enable-encoder=mpeg1video \
		--enable-encoder=mpeg2video \
		--enable-encoder=png
CONFIG_FLAGS_${P} += \
		--disable-decoders \
		--enable-decoder=aac \
		--enable-decoder=dca \
		--enable-decoder=dvbsub \
		--enable-decoder=dvdsub \
		--enable-decoder=flac \
		--enable-decoder=h261 \
		--enable-decoder=h263 \
		--enable-decoder=h263i \
		--enable-decoder=h264 \
		--enable-decoder=mjpeg \
		--enable-decoder=mp3 \
		--enable-decoder=mpeg1video \
		--enable-decoder=mpeg2video \
		--enable-decoder=msmpeg4v1 \
		--enable-decoder=msmpeg4v2 \
		--enable-decoder=msmpeg4v3 \
		--enable-decoder=pcm_s16le \
		--enable-decoder=pcm_s16be \
		--enable-decoder=pcm_s16le_planar \
		--enable-decoder=pcm_s16be_planar \
		--enable-decoder=pgssub \
		--enable-decoder=png \
		--enable-decoder=srt \
		--enable-decoder=subrip \
		--enable-decoder=subviewer \
		--enable-decoder=subviewer1 \
		--enable-decoder=text \
		--enable-decoder=theora \
		--enable-decoder=vorbis \
		--enable-decoder=wmv3 \
		--enable-decoder=xsub
CONFIG_FLAGS_${P} += \
		--disable-demuxers \
		--enable-demuxer=aac \
		--enable-demuxer=ac3 \
		--enable-demuxer=avi \
		--enable-demuxer=dts \
		--enable-demuxer=flac \
		--enable-demuxer=flv \
		--enable-demuxer=hds \
		--enable-demuxer=hls \
		--enable-demuxer=image* \
		--enable-demuxer=matroska \
		--enable-demuxer=mjpeg \
		--enable-demuxer=mov \
		--enable-demuxer=mp3 \
		--enable-demuxer=mpegts \
		--enable-demuxer=mpegtsraw \
		--enable-demuxer=mpegps \
		--enable-demuxer=mpegvideo \
		--enable-demuxer=ogg \
		--enable-demuxer=pcm_s16be \
		--enable-demuxer=pcm_s16le \
		--enable-demuxer=rm \
		--enable-demuxer=rtp \
		--enable-demuxer=rtsp \
		--enable-demuxer=srt \
		--enable-demuxer=vc1 \
		--enable-demuxer=wav
CONFIG_FLAGS_${P} += \
		--disable-protocols \
		--enable-protocol=bluray \
		--enable-protocol=file \
		--enable-protocol=http \
		--enable-protocol=mmsh \
		--enable-protocol=mmst \
		--enable-protocol=rtmp \
		--enable-protocol=rtmpe \
		--enable-protocol=rtmps \
		--enable-protocol=rtmpt \
		--enable-protocol=rtmpte \
		--enable-protocol=rtmpts
CONFIG_FLAGS_${P} += \
		--disable-filters \
		--enable-filter=scale
CONFIG_FLAGS_${P} += \
		--disable-postproc \
		--disable-bsfs \
		--disable-indevs \
		--disable-outdevs \
		--enable-bzlib \
		--enable-zlib \
		$(FFMPEG_FLAGS)
CONFIG_FLAGS_${P} += \
		--disable-static \
		--enable-shared \
		--enable-small \
		--enable-libbluray \
		--enable-protocol=bluray \
		--enable-nonfree \
		--enable-openssl \
		--enable-stripping \
		--disable-debug \
		--disable-runtime-cpudetect \
		--pkg-config="pkg-config" \
		--enable-cross-compile \
		--cross-prefix=$(target)- \
		--target-os=linux \
		--arch=sh4 \
		--enable-pthreads \
		--prefix=/usr


$(TARGET_${P}).do_prepare: $(DEPENDS_${P})
	$(PREPARE_${P})
	touch $@

$(TARGET_${P}).do_compile: $(TARGET_${P}).do_prepare
	cd $(DIR_${P}) && \
		$(BUILDENV) \
		./configure \
			--extra-cflags="-I$(targetprefix)/usr/include -ffunction-sections -fdata-sections" \
			--extra-ldflags="-L$(targetprefix)/usr/lib -Wl,--gc-sections,-lrt" \
			$(CONFIG_FLAGS_${P}) \
		&& \
		$(run_make)
	touch $@

$(TARGET_${P}).do_package: $(TARGET_${P}).do_compile
	$(PKDIR_clean)
	cd $(DIR_${P}) && $(run_make) install DESTDIR=$(PKDIR)
	touch $@

call[[ ipk ]]

RDEPENDS_ffmpeg = librtmp1 libbluray
FILES_ffmpeg = /usr/lib/*.so.* /usr/bin/ffmpeg

call[[ ipkbox ]]

]]package
