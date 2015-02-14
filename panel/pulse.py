#!/usr/bin/env python

import dbus
import os
from gi.repository import GObject as gobject
from dbus.mainloop.glib import DBusGMainLoop

gobject.threads_init()

DBusGMainLoop(set_as_default=True)

def volume_update_cb(volume):
    print(volume)

def connect():
    if 'PULSE_DBUS_SERVER' in os.environ:
        address = os.environ['PULSE_DBUS_SERVER']
    else:
        bus = dbus.SessionBus()
        server_lookup = bus.get_object("org.PulseAudio1", "/org/pulseaudio/server_lookup1")
        address = server_lookup.Get("org.PulseAudio.ServerLookup1", "Address", dbus_interface="org.freedesktop.DBus.Properties")

    return dbus.connection.Connection(address)


conn = connect()
core = conn.get_object('org.PulseAudio.Core1', "/org/pulseaudio/core1")

print("Successfully connected to " + core.Get("org.PulseAudio.Core1", "Name", dbus_interface="org.freedesktop.DBus.Properties") + "!")

streams = core.Get('org.PulseAudio.Core1', "PlaybackStreams", dbus_interface=dbus.PROPERTIES_IFACE)
stream = conn.get_object(object_path=streams[0])

device_path = stream.Get('org.PulseAudio.Core1.Stream', "Device", dbus_interface=dbus.PROPERTIES_IFACE)
device = conn.get_object(object_path=device_path)
print("Current volume is: " + str(round(device.Get('org.PulseAudio.Core1.Device', "Volume", dbus_interface=dbus.PROPERTIES_IFACE)[0] / 65537 * 100)))

device.connect_to_signal("MuteUpdated", volume_update_cb)

mainloop = gobject.MainLoop()
mainloop.run()


#print(props)
