import QtQuick
import "../"
import "fmt.js" as F

Item {
    id: m

    property string icon: ""
    property real iconPx: 11.1 * Sys.barScale
    property string text: ""
    property real px: 11.1 * Sys.barScale
    property bool emoji: false
    // the text starts a set gap after the icon's ink, not after its cell (whose spare room, plus a space in the text,
    // left volume and network further from their icons than the calendar's 8px)
    property bool tightIcon: false
    property color fg
    property bool line: true
    property int padL: Sys.barPx(4)
    property int padR: padL
    property int marginR: 0
    property int barH: 22
    property string tip: ""
    property bool wheel: false
    property var bar: null

    signal pressed(int button)
    signal scrolled(int dir)

    readonly property var runs: [{ t: icon, px: iconPx }, { t: text, px: px, emoji: emoji }]
    readonly property int need: visible ? F.lineH(runs) + (line ? 2 : 0) : 0
    // the text sits where a section without an icon puts it (the same line all along the bar); a bigger icon is
    // centred on it (below), not allowed to push it down. Above the underline's place even with no underline
    // (the window title), so it's level with the workspace numbers and the rest
    readonly property int base: F.baseline(barH, 0, 2, text !== "" ? [runs[1]] : runs)
    // the icon's cell, or as far as it really draws plus a little gap when it's wider (the volume icons are): the text
    // after it never runs into it
    readonly property int iconW: icon === "" ? 0 : (tightIcon ? Math.ceil(iconInk.tightBoundingRect.x + iconInk.tightBoundingRect.width) + 6 : Math.max(F.runWidth(icon, iconPx, false, Sys.barScale), Math.ceil(iconInk.tightBoundingRect.x + iconInk.tightBoundingRect.width) + 2))

    TextMetrics {
        id: iconInk
        text: m.icon
        font.family: "JetBrainsMono Nerd Font"
        font.bold: true
        font.pointSize: m.iconPx * 0.75
        font.hintingPreference: Font.PreferVerticalHinting
    }

    visible: icon !== "" || text !== ""
    implicitWidth: padL + iconW + F.runWidth(text, px, emoji, Sys.barScale) + padR + marginR
    implicitHeight: barH

    Rectangle {
        visible: m.line
        width: m.width - m.marginR
        height: 2
        y: m.barH - 2
        color: m.fg
    }

    BarText {
        x: m.padL
        // a bigger icon on the text's baseline sits high (icons are centred on the font's middle, which grows
        // with the size): down by the difference, so its middle meets the text's
        y: m.base - baselineOffset + Math.round(0.36 * Math.max(0, m.iconPx - m.px))
        text: m.icon
        px: m.iconPx
        color: m.fg
    }

    BarText {
        x: m.padL + m.iconW
        y: m.base - baselineOffset
        text: m.text
        px: m.px
        emoji: m.emoji
        color: m.fg
    }

    MouseArea {
        anchors.fill: parent
        anchors.rightMargin: m.marginR
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        hoverEnabled: m.tip !== ""
        onPressed: e => {
            if (m.bar)
                m.bar.hideTip(m);
            m.pressed(e.button);
        }
        onEntered: if (m.bar) m.bar.showTip(m, mouseX)
        onExited: if (m.bar) m.bar.hideTip(m)
        onWheel: e => {
            if (!m.wheel) {
                e.accepted = false;
                return;
            }
            const d = e.angleDelta.y !== 0 ? e.angleDelta.y : -e.angleDelta.x;
            if (d !== 0)
                m.scrolled(d > 0 ? 1 : -1);
        }
    }
}
