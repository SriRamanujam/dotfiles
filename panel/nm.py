#/usr/bin/env python3

import logging
import sys

from gi.repository import GObject as gobject
import dbus
from dbus.mainloop.glib import DBusGMainLoop
import time


# Logging setup
log = logging.getLogger("nm")
log.setLevel(10);
log.addHandler(logging.StreamHandler())

nm = None
mainloop = gobject.MainLoop()
current_active_ap = None

DBusGMainLoop(set_as_default=True) # what a horrid way to do this

bus = dbus.SystemBus()

def network_changes_cb(signal_props):
    log.debug(signal_props)
    log.debug("Now in the bit where things happen")

    try:
        new_access_point = bus.get_object('org.freedesktop.NetworkManager',
                signal_props['ActiveConnections'][0]).Get(
                        'org.freedesktop.NetworkManager.Connections.Active',
                        'SpecificObject',
                        dbus_interface=dbus.PROPERTIES_IFACE
                        )
    except Exception as e:
        log.error("ERROR: hit an exception, {}".format(e))

    current_active_ap = new_access_point
    log.debug("New access point is: {}".format(str(current_active_ap)))
    mainloop.quit()
    log.debug("Quit mainloop")
    nm = bus.get_object('org.freedesktop.NetworkManager', current_active_ap)
    ssid = nm.Get('org.freedesktop.NetworkManager.AccessPoint', 'Ssid', dbus_interface=dbus.PROPERTIES_IFACE, byte_arrays=True)
    log.info("NANewSSID: {}".format(ssid.decode('utf-8')))
    nm.connect_to_signal("PropertiesChanged", network_notify_cb)
    log.debug("restarting mainloop")
    mainloop.run()

def network_notify_cb(signal_dict):
    print("NStrength: {}".format(int(signal_dict['Strength'])))

def nm_state_init():
    nm = bus.get_object(
            'org.freedesktop.NetworkManager',
            '/org/freedesktop/NetworkManager'
            )
    connections = nm.Get('org.freedesktop.NetworkManager',
            'ActiveConnections',
            dbus_interface=dbus.PROPERTIES_IFACE)
    try:
        access_point = bus.get_object('org.freedesktop.NetworkManager',
                connections[0]
                ).Get('org.freedesktop.NetworkManager.Connection.Active',
                      'SpecificObject',
                      dbus_interface=dbus.PROPERTIES_IFACE)
    except IndexError as e:
        log.error("ERROR: hit an indexerror, {}".format(e))
        return None
    return access_point

current_active_ap = nm_state_init()
if current_active_ap is not None:
    nm = bus.get_object('org.freedesktop.NetworkManager', current_active_ap)
    current_ssid = nm.Get('org.freedesktop.NetworkManager.AccessPoint', 'Ssid', dbus_interface=dbus.PROPERTIES_IFACE, byte_arrays=True)
    log.info("NAInitialSSID: {}".format(current_ssid.decode('utf-8')))
    current_strength = nm.Get('org.freedesktop.NetworkManager.AccessPoint', 'Strength', dbus_interface=dbus.PROPERTIES_IFACE)
    log.info("NStrength: {}".format(int(current_strength)))
    nm.connect_to_signal("PropertiesChanged", network_notify_cb)
else:
    log.error("No active AP, your life is sad because you have no internet")


mainloop.run()
