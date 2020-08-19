#!/bin/sh

application=/usr/bin/top

chvt 11
$application > /dev/tty11 < /dev/tty11 &
