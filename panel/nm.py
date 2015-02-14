#/usr/bin/env python3

from gi.repository import GObject as gobject
import dbus
from dbus.mainloop.glib import DBusGMainLoop
import time
import multiprocessing
import subprocess
import sys

gobject.threads_init()

def network_notify_cb(signal_dict):
    print("Strength: {}".format(int(signal_dict['Strength'])))

DBusGMainLoop(set_as_default=True) # what a horrid way to do this

bus = dbus.SystemBus()

def nm_state_init():
    nm = bus.get_object(
            'org.freedesktop.NetworkManager',
            '/org/freedesktop/NetworkManager'
            )
    connections = nm.Get('org.freedesktop.NetworkManager',
            'ActiveConnections',
            dbus_interface=dbus.PROPERTIES_IFACE)
    access_point = bus.get_object('org.freedesktop.NetworkManager',
            connections[0]
            ).Get('org.freedesktop.NetworkManager.Connection.Active',
                  'SpecificObject',
                  dbus_interface=dbus.PROPERTIES_IFACE)
    return access_point

ap = nm_state_init()
nm = bus.get_object('org.freedesktop.NetworkManager', ap)
nm.connect_to_signal("PropertiesChanged", network_notify_cb)

sys.stdout.write("hello this is nm.py")
mainloop = gobject.MainLoop()
mainloop.run()
