#!/usr/bin/env python3
import sys
import os
import json
import subprocess
import cairo
import gi

gi.require_version("Gtk", "3.0")
gi.require_version("GtkLayerShell", "0.1")
from gi.repository import Gtk, Gdk, GtkLayerShell, GLib

def get_noctalia_status():
    try:
        out = subprocess.check_output(["noctalia", "msg", "status"], timeout=1)
        return json.loads(out)
    except Exception:
        return {}

def toggle_noctalia():
    subprocess.run(["noctalia", "msg", "panel-toggle", "session"])

# If session panel is already open, toggle it off and exit
status = get_noctalia_status()
if status.get("activePanelId") == "session":
    toggle_noctalia()
    sys.exit(0)

win = Gtk.Window()
GtkLayerShell.init_for_window(win)
GtkLayerShell.set_namespace(win, "noctalia-session-scrim")
GtkLayerShell.set_layer(win, GtkLayerShell.Layer.TOP)
GtkLayerShell.set_exclusive_zone(win, -1)
GtkLayerShell.set_keyboard_mode(win, GtkLayerShell.KeyboardMode.NONE)

for edge in [GtkLayerShell.Edge.TOP, GtkLayerShell.Edge.BOTTOM, GtkLayerShell.Edge.LEFT, GtkLayerShell.Edge.RIGHT]:
    GtkLayerShell.set_anchor(win, edge, True)

screen = win.get_screen()
visual = screen.get_rgba_visual()
if visual:
    win.set_visual(visual)
win.set_app_paintable(True)

def on_draw(widget, cr):
    # Translucent dark tint across entire screen
    cr.set_source_rgba(0.04, 0.05, 0.08, 0.35)
    cr.set_operator(cairo.OPERATOR_SOURCE)
    cr.paint()
    return False

win.connect("draw", on_draw)

def on_click(widget, event):
    toggle_noctalia()
    Gtk.main_quit()
    return True

win.connect("button-press-event", on_click)

opened = False

def check_status():
    global opened
    st = get_noctalia_status()
    current = st.get("activePanelId")
    if current == "session":
        opened = True
    elif opened and current != "session":
        Gtk.main_quit()
        return False
    return True

GLib.timeout_add(100, check_status)

win.show_all()
GLib.idle_add(toggle_noctalia)

Gtk.main()
