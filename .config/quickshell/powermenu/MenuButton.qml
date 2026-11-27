import QtQuick
import Quickshell

// One button in a row of buttons (Launcher): its label, icon and key, and the shell command it runs.
QtObject {
    required property string command
    required property string text
    property int keybind: 0
    property string icon: ""

    function exec() {
        Quickshell.execDetached(["sh", "-c", command]);
    }
}
