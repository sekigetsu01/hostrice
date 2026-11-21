import QtQuick
import "../"

Item {
    id: dock

    property string activeTool: "none"
    property color drawColor: Pal.accentAlt
    // each tool keeps its own thickness (a thick pen doesn't make a thick arrow); strokeWidth is the one in use
    property int strokeWidth: 3
    property var toolSizes: _sizes()
    property int textFontSize: 28
    property int nextNumber: 1
    property bool userMoved: false
    property bool vertical: false
    property bool colourWheelVisible: false
    property bool _resetting: false
    property bool _syncingSize: false

    // the select-all and delay buttons (not when editing an image)
    property bool captureTools: true
    property bool fullSelected: false
    property int delaySeconds: 0
    // the watermark button, where the watermark tool is (not on the VM host)
    property bool watermark: true
    signal undoRequested
    signal redoRequested
    signal fullRequested
    signal delayRequested
    signal watermarkRequested

    readonly property var toolList: ["move", "pen", "highlighter", "rect", "circle", "arrow", "text", "line", "number"]

    function _sizes() {
        return { pen: 3, highlighter: 3, rect: 3, circle: 3, arrow: 3, line: 3, number: 3 };
    }
    // a fresh start: tool, colour, sizes and place
    function reset() {
        activeTool = "none";
        colourWheelVisible = false;
        _tipSource = null;
        toolSizes = _sizes();
        strokeWidth = 3;
        textFontSize = 28;
        drawColor = Qt.binding(() => Pal.accentAlt);
        nextNumber = 1;
        xAnim.stop();
        yAnim.stop();
        _resetting = true;
        vertical = false;
        _resetting = false;
        userMoved = false;
    }
    function _sizeFromTool() {
        if (toolSizes[activeTool] === undefined)
            return;
        _syncingSize = true;
        strokeWidth = toolSizes[activeTool];
        _syncingSize = false;
    }
    onStrokeWidthChanged: {
        if (_syncingSize || toolSizes[activeTool] === undefined)
            return;
        const t = Object.assign({}, toolSizes);
        t[activeTool] = strokeWidth;
        toolSizes = t;
    }
    onActiveToolChanged: {
        colourWheelVisible = false;
        _sizeFromTool();
    }
    // the size control: thickness for the drawing tools, letter size for text
    function changeSize(dir) {
        if (activeTool === "text")
            textFontSize = Math.max(8, Math.min(200, textFontSize + 2 * dir));
        else
            strokeWidth = Math.max(1, Math.min(40, strokeWidth + dir));
    }
    function cycleTool(dir) {
        const idx = toolList.indexOf(activeTool);
        if (idx === -1)
            activeTool = dir > 0 ? toolList[0] : toolList[toolList.length - 1];
        else
            activeTool = toolList[(idx + dir + toolList.length) % toolList.length];
    }

    // sizes follow the screen (1.0 on a ~1080px one)
    readonly property real pw: parent ? parent.width : 0
    readonly property real ph: parent ? parent.height : 0
    readonly property real uiScale: parent ? Math.max(0.55, Math.min(1.8, Math.min(pw, ph) / 1080)) : 1
    readonly property real buttonSize: 44 * uiScale
    readonly property real iconSizeSmall: 18 * uiScale
    readonly property real iconSizeMed: 20 * uiScale
    readonly property real dividerThickness: Math.max(1, uiScale)
    readonly property real outerPadShort: 28 * uiScale
    readonly property real popupDistance: 5 * uiScale

    // each button's key, printed under it
    readonly property real keySize: Math.max(10, 12 * uiScale)
    readonly property real keyGap: 3 * uiScale
    readonly property real keyRoom: keySize + keyGap
    readonly property real longSide: buttonRow.width + 48 * uiScale
    readonly property real shortSide: buttonRow.height + keyRoom + outerPadShort
    width: vertical ? shortSide : longSide
    height: vertical ? longSide : shortSide

    // bottom centre until moved; turning it sideways slides it to the left edge (and back)
    Binding on x {
        when: !dock.userMoved
        value: Math.round((dock.pw - dock.width) / 2)
        restoreMode: Binding.RestoreNone
    }
    Binding on y {
        when: !dock.userMoved
        value: Math.round(dock.ph - dock.height - dock.outerPadShort)
        restoreMode: Binding.RestoreNone
    }
    NumberAnimation on x {
        id: xAnim
        duration: 180
        easing.type: Easing.OutCubic
        running: false
    }
    NumberAnimation on y {
        id: yAnim
        duration: 180
        easing.type: Easing.OutCubic
        running: false
    }
    function snapToDefault() {
        userMoved = true;
        if (vertical) {
            xAnim.to = Math.round(outerPadShort);
            yAnim.to = Math.round((ph - longSide) / 2);
        } else {
            xAnim.to = Math.round((pw - longSide) / 2);
            yAnim.to = Math.round(ph - shortSide - outerPadShort);
        }
        xAnim.restart();
        yAnim.restart();
    }
    onVerticalChanged: if (!_resetting) Qt.callLater(snapToDefault)

    property var _tipSource: null
    function _hover(item, on) {
        if (on)
            _tipSource = item;
        else if (_tipSource === item)
            _tipSource = null;
    }
    readonly property bool _isLeft: x + width / 2 < pw / 2
    readonly property bool _isTop: y + height / 2 < ph / 2

    Rectangle {
        anchors.fill: parent
        radius: 6 * dock.uiScale
        color: Pal.color0
        border.color: Pal.accentAlt
        border.width: 1.5 * dock.uiScale
    }

    // drag the dock by its background (also stops clicks going through to the selection); it stays on screen
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.SizeAllCursor
        drag.target: dock
        drag.threshold: 2
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: dock.pw - dock.width
        drag.maximumY: dock.ph - dock.height
        onPressed: dock.userMoved = true
    }

    Item {
        anchors.centerIn: parent
        // (the keys under the buttons: turned sideways they're on the left)
        anchors.verticalCenterOffset: dock.vertical ? 0 : -dock.keyRoom / 2
        anchors.horizontalCenterOffset: dock.vertical ? dock.keyRoom / 2 : 0
        width: buttonRow.width
        height: buttonRow.height
        rotation: dock.vertical ? 90 : 0

        Row {
            id: buttonRow
            spacing: 10 * dock.uiScale

            DockButton {
                key: "p"
                tip: dock.vertical ? "Horizontal" : "Vertical"
                onClicked: dock.vertical = !dock.vertical
                Glyph {
                    text: "⇅"
                    font.pixelSize: dock.iconSizeSmall
                    color: Pal.accentAlt
                    Behavior on rotation {
                        NumberAnimation {
                            duration: 180
                        }
                    }
                }
            }
            Divider {}
            DockButton {
                key: "1"
                tip: "Move / Select"
                active: dock.activeTool === "move"
                onClicked: dock.activeTool = active ? "none" : "move"
                Glyph {
                    text: "✋"
                    font.pixelSize: dock.iconSizeSmall
                }
            }
            Divider {}
            ToolButton {
                tool: "pen"
                tip: "Pen"
                glyph: "✏️"
            }
            ToolButton {
                tool: "highlighter"
                tip: "Highlighter"
                glyph: "🖊️"
            }
            ToolButton {
                tool: "rect"
                tip: "Rectangle"
                glyph: "⬜"
            }
            ToolButton {
                tool: "circle"
                tip: "Circle"
                glyph: "⭕"
            }
            ToolButton {
                tool: "arrow"
                tip: "Arrow"
                glyph: "⬆️"
            }
            ToolButton {
                tool: "text"
                tip: "Text"
                glyph: "T"
            }
            ToolButton {
                id: lineBtn
                tool: "line"
                tip: "Line"
                Canvas {
                    anchors.centerIn: parent
                    width: dock.iconSizeMed + 4 * dock.uiScale
                    height: width
                    rotation: dock.vertical ? -90 : 0
                    property color c: lineBtn.active ? "black" : Pal.accentAlt
                    onCChanged: requestPaint()
                    onWidthChanged: requestPaint()
                    onPaint: {
                        const ctx = getContext("2d");
                        ctx.reset();
                        ctx.strokeStyle = c;
                        ctx.lineWidth = 2.5 * dock.uiScale;
                        ctx.lineCap = "round";
                        const m = width * 0.125;
                        ctx.beginPath();
                        ctx.moveTo(m, height - m);
                        ctx.lineTo(width - m, m);
                        ctx.stroke();
                    }
                }
            }
            ToolButton {
                id: numberBtn
                tool: "number"
                tip: "Number Badge"
                Rectangle {
                    anchors.centerIn: parent
                    width: 22 * dock.uiScale
                    height: width
                    radius: width / 2
                    color: "transparent"
                    border.color: numberBtn.active ? "black" : Pal.accentAlt
                    border.width: 2 * dock.uiScale
                    Text {
                        anchors.centerIn: parent
                        text: dock.nextNumber
                        color: parent.border.color
                        font.pixelSize: 11 * dock.uiScale
                        font.bold: true
                        rotation: dock.vertical ? -90 : 0
                    }
                }
            }
            Divider {}

            // how thick the tool in use draws (text: how big); scroll, click bigger, right-click smaller ([ ] too)
            Item {
                id: strokeItem
                width: dock.buttonSize * 1.3
                height: dock.buttonSize
                anchors.verticalCenter: parent.verticalCenter
                readonly property bool isText: dock.activeTool === "text"
                readonly property bool hasSize: isText || dock.toolSizes[dock.activeTool] !== undefined
                readonly property string tip: (isText ? "Text size " + dock.textFontSize : hasSize ? dock.activeTool.charAt(0).toUpperCase() + dock.activeTool.slice(1) + " thickness " + dock.strokeWidth : "Thickness") + "  ·  [ smaller  ] bigger"
                opacity: hasSize ? 1 : 0.4
                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: sizeMa.containsMouse ? Pal.over(Pal.accentAlt, 0.2) : "transparent"
                    border.color: Pal.accentAlt
                    border.width: 1.5 * dock.uiScale
                }
                Item {
                    anchors.fill: parent
                    rotation: dock.vertical ? -90 : 0
                    // a sample of the thickness
                    Rectangle {
                        visible: !strokeItem.isText
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: parent.height * 0.62 - height / 2
                        width: parent.width * 0.55
                        height: Math.max(1, Math.min(dock.strokeWidth, 12) * dock.uiScale)
                        radius: height / 2
                        color: dock.drawColor
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: strokeItem.isText ? (parent.height - height) / 2 : parent.height * 0.12
                        text: strokeItem.isText ? "Aa " + dock.textFontSize : dock.strokeWidth
                        color: Pal.accentAlt
                        font.pixelSize: (strokeItem.isText ? 12 : 11) * dock.uiScale
                        font.bold: true
                    }
                }
                KeyLabel {
                    text: "[ ]"
                }
                MouseArea {
                    id: sizeMa
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: m => dock.changeSize(m.button === Qt.RightButton ? -1 : 1)
                    onWheel: w => dock.changeSize(w.angleDelta.y > 0 ? 1 : -1)
                    onContainsMouseChanged: dock._hover(strokeItem, containsMouse)
                }
            }
            Divider {}
            DockButton {
                key: "u"
                tip: "Undo (also Ctrl+z)"
                onClicked: dock.undoRequested()
                Glyph {
                    text: "↩️"
                }
            }
            DockButton {
                key: "r"
                tip: "Redo (also Ctrl+y)"
                onClicked: dock.redoRequested()
                Glyph {
                    text: "↪️"
                }
            }
            Divider {
                visible: dock.watermark
            }
            DockButton {
                visible: dock.watermark
                key: "⇧w"
                tip: "Remove a watermark"
                onClicked: dock.watermarkRequested()
                Glyph {
                    text: "🪄"
                }
            }
            Divider {
                visible: dock.captureTools
            }
            DockButton {
                visible: dock.captureTools
                key: "a"
                tip: dock.fullSelected ? "Unselect" : "Select the full screen"
                active: dock.fullSelected
                onClicked: dock.fullRequested()
                Canvas {
                    anchors.centerIn: parent
                    width: dock.iconSizeMed
                    height: width
                    property color c: dock.fullSelected ? "black" : Pal.accentAlt
                    onCChanged: requestPaint()
                    onWidthChanged: requestPaint()
                    onPaint: {
                        const ctx = getContext("2d");
                        ctx.reset();
                        ctx.strokeStyle = c;
                        ctx.lineWidth = 2 * dock.uiScale;
                        ctx.lineCap = "round";
                        ctx.lineJoin = "round";
                        const a = ctx.lineWidth, b = width - a, k = width * 0.32;
                        ctx.beginPath();
                        ctx.moveTo(a, a + k); ctx.lineTo(a, a); ctx.lineTo(a + k, a);
                        ctx.moveTo(b - k, a); ctx.lineTo(b, a); ctx.lineTo(b, a + k);
                        ctx.moveTo(b, b - k); ctx.lineTo(b, b); ctx.lineTo(b - k, b);
                        ctx.moveTo(a + k, b); ctx.lineTo(a, b); ctx.lineTo(a, b - k);
                        ctx.stroke();
                    }
                }
            }
            DockButton {
                visible: dock.captureTools
                key: "d"
                tip: "Delay " + (dock.delaySeconds ? dock.delaySeconds + "s" : "off")
                active: dock.delaySeconds > 0
                onClicked: dock.delayRequested()
                Glyph {
                    text: dock.delaySeconds + "s"
                    font.pixelSize: dock.iconSizeSmall * 0.8
                    font.bold: true
                    color: dock.delaySeconds > 0 ? "black" : Pal.accentAlt
                }
            }
        }
    }

    Rectangle {
        visible: dock._tipSource !== null && !dock.colourWheelVisible
        color: Pal.color0
        border.color: Pal.accentAlt
        border.width: dock.dividerThickness
        radius: 4 * dock.uiScale
        width: tipText.width + 16 * dock.uiScale
        height: tipText.height + 10 * dock.uiScale
        z: 1000
        x: {
            const s = dock._tipSource;
            if (!s)
                return 0;
            if (dock.vertical)
                return dock._isLeft ? dock.width + dock.popupDistance : -width - dock.popupDistance;
            return dock.mapFromItem(s, s.width / 2, 0).x - width / 2;
        }
        y: {
            const s = dock._tipSource;
            if (!s)
                return 0;
            if (dock.vertical)
                return dock.mapFromItem(s, 0, s.height / 2).y - height / 2;
            return dock._isTop ? dock.height + dock.popupDistance : -height - dock.popupDistance;
        }
        Text {
            id: tipText
            anchors.centerIn: parent
            text: dock._tipSource ? (dock._tipSource.fullTip !== undefined ? dock._tipSource.fullTip : dock._tipSource.tip) : ""
            color: Pal.accentAlt
            font.pixelSize: 12 * dock.uiScale
            font.family: "monospace"
        }
    }

    Rectangle {
        id: colourWheel
        visible: dock.colourWheelVisible
        width: 220 * dock.uiScale
        height: 270 * dock.uiScale
        radius: 6 * dock.uiScale
        color: Pal.color0
        border.color: Pal.accentAlt
        border.width: 1.5 * dock.uiScale
        z: 1001
        x: dock.vertical ? (dock._isLeft ? dock.width + dock.popupDistance : -width - dock.popupDistance) : Math.max(-dock.x, Math.min(dock.pw - dock.x - width, (dock.width - width) / 2))
        y: dock.vertical ? Math.max(-dock.y, Math.min(dock.ph - dock.y - height, (dock.height - height) / 2)) : dock._isTop ? dock.height + dock.popupDistance : -height - dock.popupDistance

        function updateCol() {
            dock.drawColor = Qt.hsva(picker.h, picker.s, picker.v, 1);
        }

        MouseArea {
            anchors.fill: parent
        }

        Item {
            id: picker
            anchors {
                fill: parent
                margins: 15 * dock.uiScale
                bottomMargin: 70 * dock.uiScale
            }
            property real h: 0.5
            property real s: 1
            property real v: 1

            Canvas {
                id: svBox
                anchors.fill: parent
                onPaint: {
                    const ctx = getContext("2d");
                    ctx.reset();
                    const gH = ctx.createLinearGradient(0, 0, width, 0);
                    gH.addColorStop(0, "white");
                    gH.addColorStop(1, Qt.hsva(picker.h, 1, 1, 1));
                    ctx.fillStyle = gH;
                    ctx.fillRect(0, 0, width, height);
                    const gV = ctx.createLinearGradient(0, 0, 0, height);
                    gV.addColorStop(0, "rgba(0,0,0,0)");
                    gV.addColorStop(1, "rgba(0,0,0,1)");
                    ctx.fillStyle = gV;
                    ctx.fillRect(0, 0, width, height);
                }
            }
            Rectangle {
                x: picker.s * parent.width - width / 2
                y: (1 - picker.v) * parent.height - height / 2
                width: 12 * dock.uiScale
                height: width
                radius: width / 2
                color: "transparent"
                border.color: picker.v > 0.4 ? "black" : "white"
                border.width: 2 * dock.uiScale
            }
            MouseArea {
                anchors.fill: parent
                function pick(m) {
                    picker.s = Math.max(0, Math.min(1, m.x / width));
                    picker.v = Math.max(0, Math.min(1, 1 - m.y / height));
                    colourWheel.updateCol();
                }
                onPressed: m => pick(m)
                onPositionChanged: m => pick(m)
            }
        }

        Rectangle {
            id: hueSlider
            height: 14 * dock.uiScale
            radius: height / 2
            clip: true
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: 15 * dock.uiScale
                bottomMargin: 43 * dock.uiScale
            }
            Canvas {
                anchors.fill: parent
                onPaint: {
                    const ctx = getContext("2d");
                    ctx.reset();
                    const g = ctx.createLinearGradient(0, 0, width, 0);
                    for (let i = 0; i <= 12; i++)
                        g.addColorStop(i / 12, Qt.hsva(i / 12, 1, 1, 1));
                    ctx.fillStyle = g;
                    ctx.fillRect(0, 0, width, height);
                }
            }
            Rectangle {
                x: picker.h * (hueSlider.width - width)
                y: (parent.height - height) / 2
                width: 10 * dock.uiScale
                height: 18 * dock.uiScale
                radius: 3 * dock.uiScale
                color: "transparent"
                border.color: "white"
                border.width: 2 * dock.uiScale
            }
            MouseArea {
                anchors.fill: parent
                function pick(m) {
                    picker.h = Math.max(0, Math.min(1, m.x / width));
                    svBox.requestPaint();
                    colourWheel.updateCol();
                }
                onPressed: m => pick(m)
                onPositionChanged: m => pick(m)
            }
        }

        Rectangle {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 10 * dock.uiScale
            }
            width: 48 * dock.uiScale
            height: 22 * dock.uiScale
            color: dock.drawColor
            border.color: "white"
            radius: 4 * dock.uiScale
        }
    }

    component Divider: Rectangle {
        width: dock.dividerThickness
        height: 26 * dock.uiScale
        anchors.verticalCenter: parent.verticalCenter
        color: Pal.color8
    }

    component Glyph: Text {
        anchors.centerIn: parent
        font.pixelSize: dock.iconSizeMed
        rotation: dock.vertical ? -90 : 0
    }

    // a key, printed under its button
    component KeyLabel: Text {
        anchors.top: parent.bottom
        anchors.topMargin: dock.keyGap
        anchors.horizontalCenter: parent.horizontalCenter
        rotation: dock.vertical ? -90 : 0
        color: Pal.accentAlt
        opacity: 0.85
        font.pixelSize: dock.keySize
        font.family: "monospace"
        font.bold: true
    }

    component DockButton: Item {
        id: btn
        property string key: ""
        property string tip: ""
        property string fullTip: key ? tip + "  ·  " + key : tip
        property bool active: false
        default property alias content: iconSlot.children
        signal clicked
        signal rightClicked
        width: dock.buttonSize
        height: dock.buttonSize
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: btn.active ? Pal.accentAlt : ma.containsMouse ? Pal.over(Pal.accentAlt, 0.2) : "transparent"
            border.color: Pal.accentAlt
            border.width: 1.5 * dock.uiScale
        }
        Item {
            id: iconSlot
            anchors.fill: parent
        }
        KeyLabel {
            visible: btn.key !== ""
            text: btn.key
        }
        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: m => m.button === Qt.RightButton ? btn.rightClicked() : btn.clicked()
            onContainsMouseChanged: dock._hover(btn, containsMouse)
        }
    }

    // a drawing tool: click picks it (again drops it), right-click picks it, then opens the colours
    component ToolButton: DockButton {
        id: tb
        property string tool
        property string glyph
        key: String(dock.toolList.indexOf(tool) + 1)
        fullTip: tip + "  ·  " + key + "   (o or right-click: colour)"
        active: dock.activeTool === tool
        onClicked: dock.activeTool = active ? "none" : tool
        onRightClicked: {
            if (active)
                dock.colourWheelVisible = !dock.colourWheelVisible;
            else
                dock.activeTool = tool;
        }
        Glyph {
            text: tb.glyph
            font.bold: true
            color: tb.active ? "black" : Pal.accentAlt
        }
        Rectangle {
            anchors {
                bottom: parent.bottom
                right: parent.right
                margins: 4 * dock.uiScale
            }
            z: 1
            width: 8 * dock.uiScale
            height: width
            radius: width / 2
            color: dock.drawColor
            border.color: "black"
        }
    }
}
