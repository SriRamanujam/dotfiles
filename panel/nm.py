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

def network_changes_cb(signal_props, sender=None):
    global current_active_ap
    global nm
    log.debug("Now in the bit where things happen: {}".format(signal_props))
    new_access_point = None

    try:
        if signal_props["State"] == 70:
            new_con = bus.get_object('org.freedesktop.NetworkManager', signal_props['PrimaryConnection'])
            con_iface = dbus.Interface(new_con, dbus.PROPERTIES_IFACE)
            new_access_point = con_iface.Get('org.freedesktop.NetworkManager.Connection.Active', 'SpecificObject')
        else:
            log.info("NANewSSID: ")
            return
    except Exception as e:
        log.error("ERROR: hit exception {}".format(e))
        log.info("NANewSSID: ")
        return

    match_str = "type='signal',sender='{}',path='{}',member='PropertiesChanged'".format(sender, str(current_active_ap))

    current_active_ap = new_access_point
    log.debug("New access point is: {}".format(str(current_active_ap)))
    nm = bus.get_object('org.freedesktop.NetworkManager', current_active_ap)
    ssid = nm.Get('org.freedesktop.NetworkManager.AccessPoint', 'Ssid', dbus_interface=dbus.PROPERTIES_IFACE, byte_arrays=True)
    log.info("NANewSSID: {}".format(ssid.decode('utf-8')))
    
    if current_signal is not None:
        current_signal.remove()
        current_signal = nm.connect_to_signal("PropertiesChanged", network_notify_cb)

def network_notify_cb(signal_dict):
    log.info("NStrength: {}".format(int(signal_dict['Strength'])))

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
nm_root = bus.get_object('org.freedesktop.NetworkManager', '/org/freedesktop/NetworkManager')
nm_root.connect_to_signal('PropertiesChanged', network_changes_cb, sender_keyword='sender')
current_signal = None

if current_active_ap is not None:
    nm = bus.get_object('org.freedesktop.NetworkManager', current_active_ap)
    current_ssid = nm.Get('org.freedesktop.NetworkManager.AccessPoint', 'Ssid', dbus_interface=dbus.PROPERTIES_IFACE, byte_arrays=1)
    log.info("NAInitialSSID: {}".format(current_ssid.decode('utf-8')))
    current_strength = nm.Get('org.freedesktop.NetworkManager.AccessPoint', 'Strength', dbus_interface=dbus.PROPERTIES_IFACE)
    log.info("NStrength: {}".format(int(current_strength)))
    current_signal = nm.connect_to_signal("PropertiesChanged", network_notify_cb)
else:
    log.error("No active AP, your life is sad because you have no internet")

mainloop.run()
