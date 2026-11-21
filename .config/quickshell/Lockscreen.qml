import QtQuick
import Quickshell
import Quickshell.Wayland
import "./lockscreen"

Scope {
    id: lockscreen

    function lock() {
        // a lock lost unnoticed would block this one
        _checkLost();
        ctx.lock();
        _checkLost();
    }
    function _checkLost() {
        if (ctx.locked && !sessionLock.locked)
            ctx.lockLost();
    }

    LockContext {
        id: ctx
    }

    // locks after 45 minutes without keyboard, mouse or touchpad; not while something holds the screen awake (a playing
    // video, a fullscreen app: respectInhibitors)
    IdleMonitor {
        timeout: 45 * 60
        respectInhibitors: true
        onIsIdleChanged: if (isIdle && !ctx.locked) lockscreen.lock()
    }

    WlSessionLock {
        id: sessionLock
        locked: ctx.locked
        onSecureChanged: if (!sessionLock.secure) Qt.callLater(lockscreen._checkLost)
        // compositor refused or dropped the lock later on
        onLockedChanged: Qt.callLater(lockscreen._checkLost)

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: ctx
            }
        }
    }
}
