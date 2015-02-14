#!/usr/bin/env python3
#from gi.repository import GObject as gobject
#from dbus import glib
import dbus

#gobject.threads_init()
#glib.init_threads()

bus = dbus.SystemBus()


# The below lines show how to use DBus interfaces with Python, and how to introspect.
# This information comes mainly from http://en.wikibooks.org/wiki/Python_Programming/Dbus,
# with some help from StackOverflow.
manager_object = bus.get_object(
        'org.freedesktop.UPower',
        '/org/freedesktop/UPower/devices/DisplayDevice'
        )

prop_manager = dbus.Interface(manager_object, 'org.freedesktop.DBus.Properties')

thing = prop_manager.Get('org.freedesktop.UPower.Device', 'PowerSupply')

print(thing)

#polkit_manager_object = bus.get_object(
#        'org.freedesktop.PolicyKit1',
#        '/org/freedesktop/PolicyKit1/Authority'
#)
#polkit_introspection_interface = dbus.Interface(
#        manager_object,
#        dbus.INTROSPECTABLE_IFACE
#)
#
#interface = introspection_interface.Introspect()
#print(interface)
