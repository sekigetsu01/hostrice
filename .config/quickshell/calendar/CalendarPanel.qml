import QtQuick
import Quickshell
import Quickshell.Io
import "../"
import "../launcher"
import "when.js" as When

// The calendar on the VM host: the month on the left; on the right the time now, and the time in a few places.
//   h / l, arrows: a day back / on        j / k: a week on / back        t: today
//   H / L, [ / ], Page Up / Down, scrolling: a month back / on            Esc: close
LauncherPanel {
    id: root

    // the places on the right: a name, and its time zone
    readonly property var places: [
        { name: "London", zone: "Europe/London" },
        { name: "New York", zone: "America/New_York" },
        { name: "California", zone: "America/Los_Angeles" },
        { name: "Tokyo", zone: "Asia/Tokyo" }
    ]

    theme: LauncherThemeBase {
        id: theme
        panelW: 800
        // the panel's height: the month and the date under it
        searchBarH: 452 - (dividerH + maxVisibleRows * rowHeight + bottomPad)
    }

    // now, from the clock: each second while open (the minute turning, midnight passing)
    property var now: new Date()
    readonly property string today: When.iso(now)
    readonly property var todayD: When.fromIso(today)
    property string sel: today
    readonly property var selD: When.fromIso(sel)
    property int vy: todayD.getFullYear()
    property int vm: todayD.getMonth()
    property bool resume: false
    readonly property color cellBg: Pal.over(Pal.color8, 0.3)
    readonly property color cellSel: Pal.over(Pal.accent, 0.45)
    // each place's UTC offset (seconds), by zone: read on opening, so summer time is right
    property var offsets: ({})

    onOpened: {
        // your time zone read again: changed with SUPER+F3 since, the clock and the offsets follow it
        Date.timeZoneUpdated();
        now = new Date();
        if (!resume)
            select(today);
        resume = false;
        zoneProc.running = true;
        focusTimer.restart();
    }

    onKey: e => handleKey(e)

    function pad(n) {
        return (n < 10 ? "0" : "") + n;
    }

    // a place's time now, and how far it is from ours: "+9h", "−5h", "+5:30h", or "same"
    function placeTime(zone) {
        const o = offsets[zone];
        if (!o)
            return { time: "··:··", diff: "" };
        const t = new Date(now.getTime() + o.offset * 1000);
        const mins = Math.round((o.offset + now.getTimezoneOffset() * 60) / 60), a = Math.abs(mins);
        const diff = mins === 0 ? "same" : (mins > 0 ? "+" : "−") + Math.floor(a / 60) + (a % 60 ? ":" + pad(a % 60) : "") + "h";
        return { time: pad(t.getUTCHours()) + ":" + pad(t.getUTCMinutes()), diff: diff };
    }

    // months counted from year 0, to compare and step them
    function idx(y, m) {
        return y * 12 + m;
    }
    function showMonth(i) {
        vy = Math.floor(i / 12);
        vm = i % 12;
    }

    function select(day) {
        sel = day;
        const i = idx(selD.getFullYear(), selD.getMonth());
        if (i !== idx(vy, vm))
            showMonth(i);
    }

    function moveDay(n) {
        select(When.iso(When.addDays(selD, n)));
    }

    function moveMonth(n) {
        const t = new Date(selD.getFullYear(), selD.getMonth() + n, 1);
        const last = new Date(t.getFullYear(), t.getMonth() + 1, 0).getDate();
        select(When.iso(new Date(t.getFullYear(), t.getMonth(), Math.min(selD.getDate(), last))));
    }

    // shell.qml: the calendar left open on another tag counts as open, and is put away with the other panels
    readonly property bool parked: tagHome.parked

    function setAside() {
        tagHome.parked = false;
        if (visible && !closing)
            hide();
    }

    function handleKey(e) {
        const k = e.key, t = e.text;
        e.accepted = true;
        if (k === Qt.Key_Escape)
            hide();
        else if (t === "t")
            select(today);
        else if (t === "H" || t === "[" || k === Qt.Key_PageUp)
            moveMonth(-1);
        else if (t === "L" || t === "]" || k === Qt.Key_PageDown)
            moveMonth(1);
        else if (t === "h" || k === Qt.Key_Left)
            moveDay(-1);
        else if (t === "l" || k === Qt.Key_Right)
            moveDay(1);
        else if (t === "k" || k === Qt.Key_Up)
            moveDay(-7);
        else if (t === "j" || k === Qt.Key_Down)
            moveDay(7);
        else
            e.accepted = false;
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.visible
        onActivated: root.hide()
    }

    Timer {
        id: focusTimer
        interval: 30
        onTriggered: root.focusPanel()
    }

    Timer {
        interval: 1000
        repeat: true
        running: root.visible
        onTriggered: root.now = new Date()
    }

    TagHome {
        id: tagHome
        panel: root
        onBack: {
            root.resume = true;
            root.open();
        }
    }

    // ZONE<tab>OFFSET<tab>ABBR for each place, from Python's time zone data (the system's)
    Process {
        id: zoneProc
        command: ["python3", "-I", "-c", "import datetime, zoneinfo, sys\nn = datetime.datetime.now(datetime.timezone.utc)\nfor z in sys.argv[1:]:\n    d = n.astimezone(zoneinfo.ZoneInfo(z))\n    print(z, int(d.utcoffset().total_seconds()), d.tzname(), sep='\\t')"].concat(root.places.map(p => p.zone))
        stdout: StdioCollector {
            onStreamFinished: {
                const o = {};
                text.split("\n").forEach(l => {
                    const f = l.split("\t");
                    if (f.length === 3)
                        o[f[0]] = { offset: +f[1], abbr: f[2] };
                });
                root.offsets = o;
            }
        }
    }

    // the month
    Item {
        x: 22
        y: 20
        width: 374
        height: 420

        CalMonth {
            year: root.vy
            mon: root.vm
            theme: root.theme
            sel: root.sel
            today: root.today
            cellBg: root.cellBg
            cellSel: root.cellSel
            onPicked: day => root.select(day)
        }

        Text {
            x: 6
            height: 34
            verticalAlignment: Text.AlignVCenter
            text: "◂"
            color: Pal.accent
            font.pixelSize: 15
            MouseArea {
                anchors.fill: parent
                anchors.margins: -8
                onClicked: root.moveMonth(-1)
            }
        }

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 6
            height: 34
            verticalAlignment: Text.AlignVCenter
            text: "▸"
            color: Pal.accent
            font.pixelSize: 15
            MouseArea {
                anchors.fill: parent
                anchors.margins: -8
                onClicked: root.moveMonth(1)
            }
        }

        Text {
            y: 398
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: When.longDate(root.selD, null)
            color: theme.clrTextSecond
            font.pixelSize: 11
            font.family: "monospace"
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            onWheel: w => root.moveMonth(w.angleDelta.y > 0 ? -1 : 1)
        }
    }

    Rectangle {
        x: 418
        y: 20
        width: 1
        height: 412
        color: theme.clrDivider
    }

    // the time now, and the places
    Item {
        x: 441
        y: 20
        width: theme.panelW - x - 22
        height: 412

        Text {
            y: 52
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: root.pad(root.now.getHours()) + ":" + root.pad(root.now.getMinutes())
            color: theme.clrTextPrim
            font.pixelSize: 64
            font.bold: true
            font.family: "monospace"
        }

        Text {
            y: 136
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: Qt.formatDate(root.now, "dddd d MMMM")
            color: theme.clrTextSecond
            font.pixelSize: 12
            font.family: "monospace"
        }

        Rectangle {
            x: 20
            y: 176
            width: parent.width - 40
            height: 1
            color: theme.clrDivider
        }

        Column {
            x: 20
            y: 196
            width: parent.width - 40
            spacing: 6

            Repeater {
                model: root.places

                Item {
                    id: place
                    required property var modelData
                    readonly property var t: root.placeTime(modelData.zone)
                    width: parent.width
                    height: 44

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: place.modelData.name
                        color: theme.clrTextPrim
                        font.pixelSize: 13
                        font.family: "monospace"
                    }

                    Text {
                        anchors.right: time.left
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: place.t.diff
                        color: theme.clrTextMuted
                        font.pixelSize: 11
                        font.family: "monospace"
                    }

                    Text {
                        id: time
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        text: place.t.time
                        color: theme.clrTextPrim
                        font.pixelSize: 16
                        font.bold: true
                        font.family: "monospace"
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: theme.clrDivider
                        opacity: 0.5
                    }
                }
            }
        }
    }
}
