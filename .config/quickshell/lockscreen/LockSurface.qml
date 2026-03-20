import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Wayland
import Quickshell.Io

Rectangle {
    id: root
    required property LockContext context

    property string wallpaperPath: ""
    property var theme: ({
            clock: "#4B0082",
            locked: "#7675C4",
            verticalOffset: -75
        })

    Process {
        id: wallpaperPicker
        command: ["bash", "/home/user/.config/quickshell/lockscreen/wallpapers/picker.sh"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                const parts = line.trim().split("|");
                root.wallpaperPath = parts[0];
                root.theme = {
                    clock: parts[1],
                    locked: parts[2],
                    verticalOffset: parseInt(parts[3])
                };
            }
        }
    }

    Image {
        anchors.fill: parent
        source: root.wallpaperPath ? "file://" + root.wallpaperPath : ""
        fillMode: Image.PreserveAspectCrop
    }

    ColumnLayout {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: root.theme.verticalOffset
        spacing: 2

        // time with thick outline
        Item {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: clockText.implicitWidth
            implicitHeight: clockText.implicitHeight

            Repeater {
                model: [[-2, -2], [2, -2], [-2, 2], [2, 2], [-3, 0], [3, 0], [0, -3], [0, 3]]
                Text {
                    font.pointSize: 75
                    font.weight: Font.Black
                    color: "#000000"
                    x: modelData[0]
                    y: modelData[1]
                    text: clockText.text
                }
            }

            Text {
                id: clockText
                font.pointSize: 75
                font.weight: Font.Black
                color: root.theme.clock
                text: {
                    const h = root.context.now.getHours().toString().padStart(2, '0');
                    const m = root.context.now.getMinutes().toString().padStart(2, '0');
                    return h + ":" + m;
                }
            }
        }

        Item {
            Layout.preferredHeight: 12
        }

        // password box
        Rectangle {
            id: passwordBox
            Layout.alignment: Qt.AlignHCenter
            width: 340
            height: 44
            color: "#1a1a1a"
            radius: 8
            border.width: 1.5
            border.color: {
                if (root.context.showSuccess)
                    return "#4caf50";
                if (root.context.showFailure)
                    return "#f44336";
                return "#333333";
            }

            SequentialAnimation {
                id: shakeAnim
                NumberAnimation {
                    target: passwordBox
                    property: "x"
                    to: passwordBox.x - 10
                    duration: 50
                }
                NumberAnimation {
                    target: passwordBox
                    property: "x"
                    to: passwordBox.x + 20
                    duration: 50
                }
                NumberAnimation {
                    target: passwordBox
                    property: "x"
                    to: passwordBox.x - 20
                    duration: 50
                }
                NumberAnimation {
                    target: passwordBox
                    property: "x"
                    to: passwordBox.x + 20
                    duration: 50
                }
                NumberAnimation {
                    target: passwordBox
                    property: "x"
                    to: passwordBox.x - 10
                    duration: 50
                }
                NumberAnimation {
                    target: passwordBox
                    property: "x"
                    to: passwordBox.x
                    duration: 50
                }
            }

            TextField {
                id: field
                anchors {
                    fill: parent
                    leftMargin: 12
                    rightMargin: 12
                }
                background: null
                color: "#ffffff"
                placeholderText: root.context.unlockInProgress ? "verifying…" : "password"
                placeholderTextColor: "#444444"
                font.pointSize: 13

                focus: true
                enabled: !root.context.unlockInProgress
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData

                onTextChanged: root.context.currentText = this.text

                onAccepted: {
                    root.context.tryUnlock();
                }

                Connections {
                    target: root.context
                    function onCurrentTextChanged() {
                        field.text = root.context.currentText;
                    }
                    function onShowFailureChanged() {
                        if (root.context.showFailure)
                            shakeAnim.start();
                    }
                }
            }
        }

        // locked-for
        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 2
            font.pointSize: 13
            font.weight: Font.Bold
            color: root.theme.locked
            style: Text.Outline
            styleColor: "#000000"
            text: root.context.formatLocked(root.context.secondsLocked)
        }
    }
}
