#!/bin/bash

# This script exists to fix a python-dateutils packaging problem
# https://bugs.launchpad.net/ubuntu/+source/python-dateutil/+bug/1887664

. $(dirname $0)/functions

[ -n "$PROJECT_DIR" ] || error "PROJECT_DIR unset"
[ -d "$BOOT_MNT" ] || error "/boot partition should be mounted, but isn't"
[ -n "$P3_MNT" ] || error "P3_MNT unset"
[ -d "$P3_MNT" ] || error "partition 3 should be mounted, but isn't"
[ -n "$P3_LABEL" ] || error "P3_LABEL unset"

cache_dir="${PROJECT_DIR}/.build.cache"
mkdir -p "$cache_dir"

link="https://raw.githubusercontent.com/dateutil/dateutil/master/dateutil/zoneinfo/dateutil-zoneinfo.tar.gz"
hash="b8096d02aad4d69e883c4b00d6a660fc675e6a28"

file="$(basename $link)"
if [ ! -f "${cache_dir}/${file}" ]
then
  echo -e "\nFeching $link..."
  curl -o "${cache_dir}/${file}" "$link" 2>&1
fi

shasum -c - <<< "$hash  ${cache_dir}/${file}" && cp "${cache_dir}/${file}" "$P3_MNT"

# write a self-destructing startup script to the pi
start_script="${BOOT_MNT}/rc.local.d/02_patch_dateutil.sh"
cat > $start_script << EOF
#!/bin/sh
mv /opt/${P3_LABEL}/${file} /usr/lib/python3/dist-packages/dateutil/zoneinfo/
rm \$0
EOF
