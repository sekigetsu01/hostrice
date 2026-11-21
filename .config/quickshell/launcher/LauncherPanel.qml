import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property LauncherThemeBase theme
    default property alias content: panel.data
    property alias panelClip: panel.clip
    readonly property bool closing: closeAnim.running

    signal opened
    signal key(var ev)

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    implicitWidth: theme.panelW + theme.outerPad * 2
    implicitHeight: theme.panelH + theme.outerPad * 2

    color: "transparent"
    visible: false

    function show() {
        panel.opacity = 0;
        visible = true;
        openAnim.restart();
        opened();
    }

    function focusPanel() {
        panel.forceActiveFocus();
    }

    function hide() {
        focusPanel();
        closeAnim.restart();
    }

    function toggle() {
        if (visible)
            hide();
        else
            show();
    }

    function open() {
        if (!visible || closeAnim.running) {
            closeAnim.stop();
            show();
        }
    }

    NumberAnimation {
        id: openAnim
        target: panel
        property: "opacity"
        to: 1
        duration: 120
        easing.type: Easing.OutCubic
    }

    SequentialAnimation {
        id: closeAnim
        NumberAnimation {
            target: panel
            property: "opacity"
            to: 0
            duration: 90
            easing.type: Easing.InCubic
        }
        PropertyAction {
            target: root
            property: "visible"
            value: false
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.hide()
    }

    Rectangle {
        id: panel
        x: root.theme.outerPad
        y: root.theme.outerPad
        width: root.theme.panelW
        height: root.theme.panelH
        color: root.theme.clrBg
        radius: 4
        border.color: root.theme.clrBorder
        border.width: 1
        opacity: 0
        focus: true
        Keys.onPressed: ev => root.key(ev)

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
        }
    }
}
