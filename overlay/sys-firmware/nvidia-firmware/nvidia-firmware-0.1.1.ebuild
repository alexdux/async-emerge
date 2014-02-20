EAPI=5

inherit unpacker

NV_URI="http://us.download.nvidia.com/XFree86/"
NV_ARCH="x86_64"
NV_VER="331.38"
NV_PV="${NV_ARCH}-${NV_VER}"

DESCRIPTION="Kernel and mesa firmware for nouveau (video accel and pgraph)."
HOMEPAGE="http://nouveau.freedesktop.org/wiki/VideoAcceleration/"
SRC_URI="
https://raw.github.com/imirkin/re-vp2/0638f7a276433848288bb8143ede89d290e0a2e5/extract_firmware.py
${NV_URI}Linux-${NV_ARCH}/${NV_VER}/NVIDIA-Linux-${NV_PV}.run
"

LICENSE="MIT NVIDIA-r1"
SLOT="0"
KEYWORDS="~x86 amd64 ~ppc ~ppc64"
DEPEND="<dev-lang/python-3"
RESTRICT="bindist mirror strip"
IUSE="-bindist"
REQUIRED_USE="!bindist"

S=${WORKDIR}/

src_unpack() {
	mkdir "${S}"/NVIDIA-Linux-${NV_PV}
	cd "${S}"/NVIDIA-Linux-${NV_PV}
	unpack_makeself NVIDIA-Linux-${NV_PV}.run
}

src_compile() {
	cd "${S}"
	python2 "${DISTDIR}"/extract_firmware.py
}

src_install() {
	insinto /lib/firmware/nouveau
	doins "${S}"/nv* "${S}"/vuc-*
}
