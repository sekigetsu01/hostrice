import QtQuick
import Quickshell
import Quickshell.Io

// the calendar's key (SUPER+C: qs ipc call calendar toggle)
Scope {
    id: root

    required property var panel

    IpcHandler {
        target: "calendar"
        function toggle(): void {
            root.panel.toggle();
        }
        // whether it's showing (made, open, and not closing)
        function isOpen(): string {
            const w = root.panel.item;
            return !w ? "not made" : w.visible ? "open " + w.width + "x" + w.height : "closed";
        }
    }
}
