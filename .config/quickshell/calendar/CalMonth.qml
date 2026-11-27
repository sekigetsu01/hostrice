import QtQuick
import "../"
import "when.js" as When

// One month of the calendar (CalendarPanel): its name, the weekdays, and its 6 weeks of days. The days of the months
// either side are dimmed, and never marked today or chosen: that's for the month they belong to.
Item {
    id: month

    required property int year
    required property int mon
    required property var theme
    property string sel: ""
    property string today: ""
    property color cellBg: "transparent"
    property color cellSel: "transparent"
    readonly property var cells: When.cells(year, mon)

    signal picked(string day)

    width: 7 * 50 + 6 * 4
    height: 380

    Text {
        width: parent.width
        height: 34
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: When.monthTitle(month.year, month.mon)
        color: month.theme.clrTextPrim
        font.pixelSize: 15
        font.bold: true
        font.family: "monospace"
    }

    Row {
        y: 40
        spacing: 4
        Repeater {
            model: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            Text {
                required property string modelData
                width: 50
                horizontalAlignment: Text.AlignHCenter
                text: modelData
                color: month.theme.clrTextSecond
                font.pixelSize: 10
                font.bold: true
                font.family: "monospace"
            }
        }
    }

    Grid {
        y: 62
        columns: 7
        spacing: 4

        Repeater {
            model: month.cells

            Rectangle {
                id: cell
                required property var modelData
                readonly property bool isSel: modelData.inMonth && modelData.iso === month.sel
                readonly property bool isToday: modelData.inMonth && modelData.iso === month.today
                width: 50
                height: 50
                radius: 4
                color: isSel ? month.cellSel : modelData.inMonth ? month.cellBg : "transparent"
                border.width: isToday ? 2 : 0
                border.color: Pal.accentWarm

                Text {
                    anchors.centerIn: parent
                    text: cell.modelData.day
                    color: cell.modelData.inMonth ? month.theme.clrTextPrim : month.theme.clrTextMuted
                    font.pixelSize: 14
                    font.bold: cell.isToday || cell.isSel
                    font.family: "monospace"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: month.picked(cell.modelData.iso)
                }
            }
        }
    }
}
