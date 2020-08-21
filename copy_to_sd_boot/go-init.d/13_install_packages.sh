#!/bin/bash
exit 0

mount -t proc proc /proc


get_var_from_kcl () {
  var=$1
  for x in $(cat /proc/cmdline)
  do
    if [[ "$x" == "${var}="* ]]
    then
      eval ${var}=${x#${var}=}
    fi
  done
}

get_var_from_kcl pkg_mp
if [ -z "$pkg_mp" ]
then
  echo pkg_mp is empty
  sleep 2
fi

get_var_from_kcl pkg_dir
if [ -z "$pkg_dir" ]
then
  echo pkg_dir is empty
  sleep 2
fi

mount
echo
echo mounting $pkg_mp
mount $pkg_mp
echo
mount
echo
sleep 1
ls -l $pkg_mp
echo
sleep 1
ls -l $pkg_dir
sleep 5

if [ ! -d "$pkg_dir" ]
then
  cat /proc/cmdline
  echo pkg_dir does not exist
  sleep 10
else
  echo directory exists
  ls -l $pkg_dir
  sleep 10
  PATH=/sbin:/bin:/usr/bin dpkg -i ${pkg_dir}/*.deb
fi

umouunt $pkg_mp
umount /proc
