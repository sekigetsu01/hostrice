import QtQuick
import Quickshell
import Quickshell.Io
import "./screenshotter"
import "./powermenu"
import "./lockscreen"
import "./wallpaper"
import "./launcher/apps"
import "./launcher/emoji"
import "./launcher/calc"
import "./launcher/timezone"
import "./launcher/wifi"
import "./notifications"
import "./bar"
import "./calendar"

// The whole desktop shell (quickshell, started by mango's config.conf): the bar, lock screen, screenshotter, notifications
// and every panel, each opened by its key through qs ipc call NAME toggle; opening one puts the others away.
ShellRoot {
    id: shellRoot

    function closeOthers(keep) {
        for (const l of [powerMenu, wallpaperSelector, appLauncher, emoji, calc, timezone, wifi, calendar, notificationCenter]) {
            const w = l.item;
            if (l !== keep && w && (l === powerMenu ? w.active : l === notificationCenter ? w.panelOpen : w.visible || w.parked === true)) {
                if (typeof w.setAside === "function")
                    w.setAside();
                else
                    w.toggle();
            }
        }
    }

    Lockscreen {
        id: lockscreen
    }

    Bar {
        recording: notificationPopup.recording
        onPowermenu: powerMenu.toggle()
    }

    Screenshotter {
        id: screenshotter
    }

    LazyPanel {
        id: powerMenu
        ipc: "powermenu"
        onOpening: shellRoot.closeOthers(powerMenu)

        Launcher {
            MenuButton {
                text: "Lock"
                keybind: Qt.Key_L
                command: "qs ipc call lockscreen lock"
            }
            MenuButton {
                text: "Reboot"
                keybind: Qt.Key_R
                command: "systemctl reboot"
            }
            MenuButton {
                text: "Shutdown"
                keybind: Qt.Key_S
                command: "systemctl poweroff"
            }
        }
    }

    LazyPanel {
        id: wallpaperSelector
        ipc: "wallpaperSelector"
        onOpening: shellRoot.closeOthers(wallpaperSelector)
        WallpaperSelector {}
    }

    LazyPanel {
        id: appLauncher
        ipc: "applauncher"
        onOpening: shellRoot.closeOthers(appLauncher)
        AppLauncherPanel {}
    }

    LazyPanel {
        id: emoji
        ipc: "emojipicker"
        onOpening: shellRoot.closeOthers(emoji)
        EmojiPanel {}
    }

    LazyPanel {
        id: calc
        ipc: "calc"
        onOpening: shellRoot.closeOthers(calc)
        CalcPanel {}
    }

    IpcHandler {
        target: "calcKeys"
        Component.onCompleted: Quickshell.execDetached(["rm", "-f", (Quickshell.env("XDG_RUNTIME_DIR") || "/tmp") + "/qs-calc-side"])
        function side(key: string): bool {
            return !!calc.item && calc.item.sideKey(key);
        }
        function window(key: string): bool {
            return !!calc.item && calc.item.windowKey(key);
        }
        function typing(): bool {
            return !!calc.item && calc.item.typing;
        }
        function focus(): bool {
            if (!calc.item || !calc.item.visible)
                return false;
            calc.item.refocus();
            return true;
        }
        function release(): bool {
            if (!calc.item || !calc.item.visible || !calc.item.hasWindow)
                return false;
            calc.item.release();
            return true;
        }
    }

    LazyPanel {
        id: timezone
        ipc: "timezone"
        onOpening: shellRoot.closeOthers(timezone)
        TimezonePanel {}
    }

    LazyPanel {
        id: wifi
        ipc: "wifi"
        onOpening: shellRoot.closeOthers(wifi)
        WifiPanel {}
    }

    LazyPanel {
        id: calendar
        ipc: "calendar"
        onOpening: shellRoot.closeOthers(calendar)
        CalendarPanel {}
    }

    LazyLoader {
        id: notificationCenter
        loading: true
        NotificationCenter {}
    }

    NotificationPopup {
        id: notificationPopup
        centerRef: notificationCenter.item
        onOpenCenter: notifIpc.open()
    }

    IpcHandler {
        target: "screenshotter"
        function toggle(): void {
            screenshotter.toggle();
        }
        function editFor(path: string, pid: int): void {
            screenshotter.edit(path, pid);
        }
    }

    IpcHandler {
        target: "lockscreen"
        function lock(): void {
            lockscreen.lock();
        }
    }

    IpcHandler {
        id: notifIpc
        target: "notifications"
        function toggle(): void {
            shellRoot.closeOthers(notificationCenter);
            if (notificationCenter.item)
                notificationCenter.item.toggle();
        }
        function dismiss(): void {
            notificationPopup.dismissTop();
        }
        function open(): void {
            shellRoot.closeOthers(notificationCenter);
            if (notificationCenter.item && !notificationCenter.item.panelOpen)
                notificationCenter.item.toggle();
        }
        function recording(pid: int): void {
            notificationPopup.setRecorder(pid, false);
        }
        // a recording that shows pop-ups as usual (record-screen -s)
        function recordingShown(pid: int): void {
            notificationPopup.setRecorder(pid, true);
        }
    }
}
