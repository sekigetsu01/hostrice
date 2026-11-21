import QtQuick
import Quickshell

QtObject {
    required property string command
    required property string text
    property int keybind: 0
    // a Nerd Font glyph; the power menu's buttons get theirs from their names
    property string icon: ""
    // passed to command as $1, $2…
    property list<string> args: []

    function exec() {
        Quickshell.execDetached(["sh", "-c", command, "sh", ...args]);
    }
}
