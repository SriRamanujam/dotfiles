#! /usr/bin/env python3

import logging

import subprocess
from threading import Thread
from queue import Queue, Empty, Full

import dbus
from gi.repository import GObject as gobject
from dbus.mainloop.glib import DBusGMainLoop

def call_subprocess(cmd, queue):
    s = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    while True:
        l = s.stdout.readline().strip().decode('utf-8')
        queue.put(l)

    queue.put(l)


def nm_dbus_loop(queue):
    log = logging.getLogger("nm")
    log.setLevel(10)
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
                            'org.freedesktop.NetworkManager.Connection.Active',
                            'SpecificObject',
                            dbus_interface=dbus.PROPERTIES_IFACE)
        except KeyError:
            log.error("ERROR: hit a keyerror, {}".format(e.strerror))
            return
        except TypeError as e:
            log.error("ERROR: hit a typeerror, {}".format(e.strerror))
            return
        current_active_ap = new_access_point
        log.info("New access point is: {}".format(str(currrent_active_ap)))
        mainloop.quit()
        log.debug("Quit mainloop")
        nm = bus.get_object('org.freedesktop.NetworkManager', current_active_ap)
        ssid = nm.Get('org.freedesktop.NetworkManager.AccessPoint', 'Ssid', dbus_interface=dbus.PROPERTIES_IFACE)
        log.info("new ssid is {}".format(str(ssid)))
        nm.connect_to_signal("PropertiesChanged", network_notify_cb)
        queue.put("New SSID: {}".format(str(ssid)))
        mainloop.run()

    def network_notify_cb(signal_props):
        queue.put("Strength: {}".format(int(signal_props['Strength'])))


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
            log.error("ERROR: hit an indexerror, {}".format(e.strerror))
            return None
        return access_point

    current_active_ap = nm_state_init()

    if current_active_ap is not None:
        nm = bus.get_object('org.freedesktop.NetworkManager', current_active_ap)
        nm.connect_to_signal("PropertiesChanged", network_notify_cb)

    nm_main = bus.get_object('org.freedesktop.NetworkManager', '/org/freedesktop/NetworkManager')
    nm_main.connect_to_signal("PropertiesChanged", network_changes_cb)

    mainloop.run()


def upower_dbus_loop(queue):
    battery_state_map = {0: 'Unknown', 1: 'Charging', 2: 'Discharging', 3: 'Empty', 4: 'Fully Charged', 5:'Pending Charge', 6:'Pending Discharge' }

    def power_notify_cb(device_name, signal_props, signature_array):
        percent = signal_props['Percentage']
        bat_state = battery_state_map[int(signal_props['State'])]
        if (bat_state == "Discharging"):
            m, s = divmod(signal_props['TimeToEmpty'], 60)
            h, m = divmod(m, 60)
            time_to_empty = "%d:%02d:%02d" % (h, m, s)
            #queue.put("{}, {}% and {} until empty".format(bat_state, percent, time_to_empty))
        elif (bat_state == "Charging"):
            m, s = divmod(signal_props['TimeToFull'], 60)
            h, m = divmod(m, 60)
            time_to_full = "%d:%02d:%02d" % (h, m, s)
            #queue.put("{}, {}% and {} until full".format(bat_state, percent, time_to_full))
        elif (bat_state == "Fully Charged"):
            pass
            #queue.put("Fully Charged")
        else:
            pass
            #queue.put("Something went wrong")

    DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()

    upower = bus.get_object(
            'org.freedesktop.UPower',
            '/org/freedesktop/UPower/devices/DisplayDevice')

    upower_manager = dbus.Interface(upower, dbus.PROPERTIES_IFACE)
    upower_manager.connect_to_signal("PropertiesChanged", power_notify_cb)
    mainloop = gobject.MainLoop()
    mainloop.run()


if __name__ == "__main__":
    commands_array = [
            ['bspc', 'control', '--subscribe'],
            ['mpc', 'idleloop', 'player', 'playlist'],
            ]
    q = Queue()
    gobject.threads_init()
    for cmd in commands_array:
        thread = Thread(target=call_subprocess, args=[cmd, q])
        thread.start()

    # starts dbus loops. I will figure out a nicer way to do this later.
    thread = Thread(target=nm_dbus_loop, args=[q])
    thread.start()
    thread = Thread(target=upower_dbus_loop, args=[q])
    thread.start()

    while True:
        print(q.get())
