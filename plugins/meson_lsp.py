#!/usr/bin/env python3

import os
import json
import gi

from gi.repository import GLib
from gi.repository import Gio
from gi.repository import GObject
from gi.repository import Ide

class MesonService(Ide.LspService):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.set_program('/usr/local/bin/meson_lsp')
        self.set_inherit_stderr(True)

    def do_configure_client(self, client):
        client.add_language("meson")

    def do_configure_launcher(self, pipeline, launcher):
        launcher.set_environ(["G_MESSAGES_DEBUG=all", "G_DEBUG=fatal-criticals"])

class MesonDiagnosticProvider(Ide.LspDiagnosticProvider, Ide.DiagnosticProvider):
    def do_load(self):
        MesonService.bind_client(self)
class MesonSymbolResolver(Ide.LspSymbolResolver):
    def do_load(self):
        MesonService.bind_client(self)
class MesonHoverProvider(Ide.LspHoverProvider):
    def do_prepare(self):
        self.props.priority = 800
        MesonService.bind_client(self)
class MesonHighlighter(Ide.LspHighlighter):
    def do_load(self):
        MesonService.bind_client(self)

