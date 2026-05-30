# ⚠️ ARCHIVED — This project is discontinued

**async-emerge** was a set of bash scripts for semi-automatic Gentoo updates using AUFS chroot.

## Why archived

- **AUFS is no longer maintained** and removed from modern kernels (6.x+)
- Dependencies are obsolete: `layman` (deprecated), `/etc/make.conf` (legacy path)
- The only useful component (`temerge` — tmpfs wrapper for emerge) has been extracted to a separate project
- Modern alternatives exist: containers, icecc for distributed builds, overlayfs

## History

- Created: 2011 (initial release)
- Last meaningful update: 2016 (AUFS/OverlayFS notes)
- Final version: 1.9-r2

## What was extracted

- `temerge` script → lives in `gentoo-admin/scripts/temerge`

---

*Archived on 2026-05-30*
