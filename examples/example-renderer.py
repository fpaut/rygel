#!/usr/bin/env python

from gi.repository import RygelCore as rc
from gi.repository import RygelRenderer as rr
from gi.repository import GObject

class ExamplePlayer(GObject.Object, rr.MediaPlayer):
    __gtype_name = "RygelPythonExamplePlayer"
    volume = GObject.property (type = float, default = 1.0)
    uri = GObject.property (type = str, default = "")
    position = GObject.property (type = int, default = 0)
    duration = GObject.property (type = int, default = 0)

    @GObject.property
    def allowed_playback_speeds(self):
        return ["1"]

    def __init__(self):
        GObject.Object.__init__(self)

d = rr.MediaRenderer (title = "DLNA renderer from Python!",
                      player = ExamplePlayer())

d.add_interface ("lo")

GObject.MainLoop().run()
