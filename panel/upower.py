#! /usr/bin/env python3

import logging

# Logging setup
log = logging.getLogger("upower")
log.setLevel(10);
log.addHandler(logging.StreamHandler())

import dbus
from gi.repository import GObject as gobject
from dbus.mainloop.glib import DBusGMainLoop

gobject.threads_init()

battery_state_map = {0: 'Unknown', 1: 'Charging', 2: 'Discharging', 3: 'Empty', 4: 'Fully Charged', 5:'Pending Charge', 6:'Pending Discharge' }

def power_notify_cb(device_name, signal_props, signature_array):
    percent = signal_props['Percentage']
    bat_state = battery_state_map[int(signal_props['State'])]
    if (bat_state == "Discharging"):
        m, s = divmod(signal_props['TimeToEmpty'], 60)
        h, m = divmod(m, 60)
        time_to_empty = "%d:%02d:%02d" % (h, m, s)
        log.info("{0}, {1:g}%, and {2} until empty".format(bat_state, percent, time_to_empty))
    elif (bat_state == "Charging"):
        m, s = divmod(signal_props['TimeToFull'], 60)
        h, m = divmod(m, 60)
        time_to_full = "%d:%02d:%02d" % (h, m, s)
        log.info("{0}, {1:g}%, and {2} until full".format(bat_state, percent, time_to_full))
    elif (bat_state == "Fully Charged"):
        log.info("Fully Charged, 100%")
    else:
        log.warning("Unknown battery status")

DBusGMainLoop(set_as_default=True)
bus = dbus.SystemBus()

upower = bus.get_object(
        'org.freedesktop.UPower',
        '/org/freedesktop/UPower/devices/DisplayDevice')

upower_manager = dbus.Interface(upower, dbus.PROPERTIES_IFACE)
current_percent = upower_manager.Get('org.freedesktop.UPower.Device', 'Percentage')
current_state = upower_manager.Get('org.freedesktop.UPower.Device', 'State')
log.info("{0}, {1:g}%".format(battery_state_map[current_state], current_percent))
upower_manager.connect_to_signal("PropertiesChanged", power_notify_cb)

mainloop = gobject.MainLoop()
mainloop.run()
