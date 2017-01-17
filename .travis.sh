#! /bin/sh

set -e -x

# the tests need the real DBus, start the daemon first
dbus-daemon --system --fork

# run the shared generic Travis script
yast-travis-cpp

