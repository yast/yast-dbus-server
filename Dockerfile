FROM yastdevel/cpp:sle12-sp5


RUN zypper --gpg-auto-import-keys --non-interactive in --no-recommends \
  dbus-1-devel \
  dbus-1-python \
  polkit-devel \
  python-devel \
  ruby-dbus \
  yast2-ruby-bindings
RUN mkdir /run/dbus
COPY . /usr/src/app
