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

ShellRoot {
    id: shellRoot

    function closeOthers(keep) {
        for (const l of [powerMenu, wallpaperSelector, appLauncher, emoji, calc, timezone, wifi, calendar, notificationCenter]) {
            const w = l.item;
            // the calendar parked on another tag counts as open: it would come back over this one
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

    // Super+h / Super+l while the calculator's open (mango/scripts/mm resize): true when they moved typing to or from it
    IpcHandler {
        target: "calcKeys"
        // the calculator open through a restart or a reload leaves its qs-calc-side behind: gone, or every window key
        // would ask a calculator that isn't there
        Component.onCompleted: Quickshell.execDetached(["rm", "-f", (Quickshell.env("XDG_RUNTIME_DIR") || "/tmp") + "/qs-calc-side"])
        function side(key: string): bool {
            return !!calc.item && calc.item.sideKey(key);
        }
        // mango's window keys (mango/scripts/calc-or): true when the calculator dealt with it
        function window(key: string): bool {
            return !!calc.item && calc.item.windowKey(key);
        }
        // Super+j / k (mango/scripts/mm step): the calculator is one of the windows they go through. Open and typing in it?
        function typing(): bool {
            return !!calc.item && calc.item.typing;
        }
        // typing in it now (false: it's closed)
        function focus(): bool {
            if (!calc.item || !calc.item.visible)
                return false;
            calc.item.refocus();
            return true;
        }
        // the keyboard to the windows (false: there's none to give it to)
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
        onOpening: shellRoot.closeOthers(calendar)
        CalendarPanel {}
    }

    CalendarDesk {
        panel: calendar
    }

    LazyLoader {
        id: notificationCenter
        loading: true
        NotificationCenter {
            onOpenPanel: name => {
                if (name === "calendar" && !(calendar.item && calendar.item.visible))
                    calendar.toggle();
            }
        }
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
        function edit(path: string): void {
            screenshotter.edit(path, 0);
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
        // the newest pop-up away (Alt+Backspace)
        function dismiss(): void {
            notificationPopup.dismissTop();
        }
        // open only, never close: for the pop-ups
        function open(): void {
            shellRoot.closeOthers(notificationCenter);
            if (notificationCenter.item && !notificationCenter.item.panelOpen)
                notificationCenter.item.toggle();
        }
        function notify(appName: string, summary: string, body: string, icon: string): void {
            notificationPopup.incoming(appName, summary, body, icon);
        }
        function recording(pid: int): void {
            notificationPopup.setRecorder(pid);
        }
    }
}
