#!/bin/sh -e

. $(dirname $0)/functions

[ -n "$PROJECT_DIR" ] || error "PROJECT_DIR unset"
[ -n "$BOOT_MNT" ] || error "BOOT_MNT unset"
[ -d "$BOOT_MNT" ] || error "$BOOT_MNT does not exist"
[ -n "$P3_MNT" ] || error "P3_MNT unset"
[ -d "$P3_MNT" ] || error "$P3_MNT does not exist"
[ -n "$P3_LABEL" ] || error "P3_LABEL unset"

# we store the application in cache_dir
git_url="https://github.com/chrismarget/keyhole.git"
project_name="$(echo $git_url | sed -e 's:^.*/\(.*\).git$:\1:')"
tar_file="${project_name}.tar"
cache_dir="${PROJECT_DIR}/.build.cache"

# fetch/update the application
if [ -d "$cache_dir/$project_name" ]
then
  git -C "$cache_dir/$project_name" pull --recurse-submodules "$git_url"
else
  git -C "$cache_dir" clone --recursive --branch master "$git_url"
fi

# roll up the application into the SD card
tar cf $P3_MNT/${project_name}.tar -C "${cache_dir}" "${project_name}"

# leave an install script on the SD card
rc_local_d="${BOOT_MNT}/rc.local.d"
install_script="${rc_local_d}/50_install_${project_name}.sh"
pi_tar_file="/opt/${P3_LABEL}/${project_name}.tar"

echo "#!/bin/sh" > $install_script
echo "mkdir -p /usr/local" >> $install_script
echo "tar xvf $pi_tar_file -C /usr/local" >> $install_script
echo "rm \$0" >> $install_script

# leave a startup script on the SD card
start_script="${rc_local_d}/99_${project_name}.sh"
start_script="${BOOT_MNT}/rc.local.d/99_keyhole.sh"
echo "#!/bin/sh" > $start_script
echo "chvt 11" >> $start_script
echo "/usr/local/keyhole/bin/keyhole > /dev/tty11 < /dev/tty11 &" >> $start_script
