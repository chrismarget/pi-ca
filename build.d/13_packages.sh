#!/bin/bash

. $(dirname $0)/functions

hash_and_link=()
hash_and_link+=('9cefff8ba90e29704f25af87f89a50527f6f613d http://archive.raspberrypi.org/debian/pool/main/r/rpi.gpio/python3-rpi.gpio_0.7.0~buster-1_armhf.deb')
hash_and_link+=('193749cab8f0f0686fa3f41f31ae0b2d5d0d93a5 http://archive.raspbian.org/raspbian/pool/main/liby/libyaml/libyaml-0-2_0.2.1-1_armhf.deb')
hash_and_link+=('a07af0fe437c1c76b82320d29bcd7447c42fbd70 http://archive.raspbian.org/raspbian/pool/main/p/python3-stdlib-extensions/python3-lib2to3_3.7.3-1_all.deb')
hash_and_link+=('83628d6c4e604137ee40a24bbfdec9af4aa8e9e1 http://archive.raspbian.org/raspbian/pool/main/p/python3-stdlib-extensions/python3-distutils_3.7.3-1_all.deb')
hash_and_link+=('c0d45518fde6cb9345dbdf321831792fafaeb153 http://archive.raspbian.org/raspbian/pool/main/p/python-uinput/python3-uinput_0.11.2-1+b1_armhf.deb')
hash_and_link+=('bd7c5ea281dd53bdd0c773fb7dbd0ac929241aa4 http://archive.raspbian.org/raspbian/pool/main/u/urwid/python3-urwid_2.0.1-2+b1_armhf.deb')
hash_and_link+=('433ea288737fcc5a7bbe1e57342595cf9a278f14 http://archive.raspbian.org/raspbian/pool/main/p/pyyaml/python3-yaml_3.13-2_armhf.deb')

[ -n "$PROJECT_DIR" ] || error "PROJECT_DIR unset"
[ -n "$P3_MNT" ] || error "P3_MNT unset"
[ -d "$P3_MNT" ] || error "partition 3 should be mounted, but isn't"
[ -n "$P3_LABEL" ] || error "P3_LABEL unset"
[ -n "$BOOT_MNT" ] || error "BOOT_MNT unset"
[ -d "$BOOT_MNT" ] || error "/boot partition should be mounted, but isn't"

cache_dir="${PROJECT_DIR}/.build.cache"
mkdir -p "$cache_dir"

pkg_dir="pkgs"
build_pkg_dir="${P3_MNT}/$pkg_dir"
mkdir -p $build_pkg_dir

i=0
while [ $i -lt ${#hash_and_link[@]} ]
do
  hash="${hash_and_link[i]:0:40}"
  link="${hash_and_link[i]:41}"
  file="${cache_dir}/$(basename $link)"
  [ -f "$file" ] || (echo -e "\nFeching $link..."; curl -o "$file" "$link")
  echo -n "Checking $file... "
  shasum -c - <<< "$hash  $file" && cp $file $build_pkg_dir
  i=$((i+1))
done

if [ $i -gt 0 ]
then
  pi_pkg_mp="/opt/${P3_LABEL}"
  pi_pkg_dir="${pi_pkg_mp}/$pkg_dir"
  cmdline=${BOOT_MNT}/cmdline.txt
  sed -i .bak "1s:$: pkg_mp=$pi_pkg_mp:" $cmdline && rm ${cmdline}.bak
  sed -i .bak "1s:$: pkg_dir=$pi_pkg_dir:" $cmdline && rm ${cmdline}.bak
fi
