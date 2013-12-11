#
# spec file for package yast2-dbus-server
#
# Copyright (c) 2013 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#

Name:           yast2-dbus-server
Version:        3.1.1
Release:        0

BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source0:        %{name}-%{version}.tar.bz2

Group:	        System/YaST
License:        GPL-2.0+
Url:	        http://en.opensuse.org/Portal:YaST
# obviously
BuildRequires:	gcc-c++ libtool
# needed for all yast packages
BuildRequires:	yast2-core-devel
BuildRequires:  yast2-devtools >= 3.1.10
# testsuite
BuildRequires:	dejagnu
# autodocs
BuildRequires:	doxygen
# docbook docs
BuildRequires:	docbook-xsl-stylesheets libxslt
# catalog: convert URIs to local filenames
BuildRequires:	sgml-skel

# for SCR DBus service
BuildRequires:	dbus-1-devel dbus-1-x11 polkit-devel
# its tests
BuildRequires:  dbus-1-python python-devel
# its tests
BuildRequires:  dbus-1-python python-devel

# to run the tests
BuildRequires:  yast2-ruby-bindings >= 1.0.0

Summary:	YaST2 - DBus Server

%description
This package contains YaST DBus service, it provides DBus access 
to YaST components.

%prep
%setup -n %{name}-%{version}

%build
%yast_build

%install
%yast_install

# remove not needed development files
rm %{buildroot}/%{yast_plugindir}/liby2dbus.la
rm %{buildroot}/%{yast_plugindir}/liby2dbus.so


%post
/sbin/ldconfig
# This is a workaround for dbus reloading too soon. (bnc#502719#c4).
# In oS 11.2 there exists rcdbus reload, so this is for a SLE backport.
# The /dev/null is a workaround for http://bugs.freedesktop.org/show_bug.cgi?id=896#c23
# But if there is nothing to reload, don't fail.
dbus-send --print-reply --system --dest=org.freedesktop.DBus / org.freedesktop.DBus.ReloadConfig >/dev/null || true

%postun
/sbin/ldconfig
dbus-send --print-reply --system --dest=org.freedesktop.DBus / org.freedesktop.DBus.ReloadConfig >/dev/null || true

%files
%defattr(-,root,root)

%{yast_plugindir}/lib*.so.*

# DBus service
%{yast_ybindir}/SCR_dbus_server
# DBus service config
/usr/share/dbus-1/system-services/org.opensuse.yast.SCR.service
%config /etc/dbus-1/system.d/org.opensuse.yast.SCR.conf
# PolicyKit default policies
/usr/share/polkit-1/actions/org.opensuse.yast.scr.policy

# DBus namespace service
%{yast_ybindir}/yast_modules_dbus_server
/usr/share/dbus-1/system-services/org.opensuse.YaST.modules.service
%config /etc/dbus-1/system.d/org.opensuse.YaST.modules.conf
/usr/share/polkit-1/actions/org.opensuse.yast.module-manager.policy

%doc %{yast_docdir}

