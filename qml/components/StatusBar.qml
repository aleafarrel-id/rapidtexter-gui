import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Rectangle {
    id: statusBar

    // Properties exposed to parent (bound to mainWindow properties)
    property string currentLanguage: "-"
    property string currentTime: "-"
    property string currentMode: "-"
    property bool sfxEnabled: true

    signal sfxToggled

    // Styling
    height: Theme.statusBarHeight
    color: Theme.bgSecondary

    // Bottom border
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: Theme.borderPrimary
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.paddingHuge
        anchors.rightMargin: Theme.paddingHuge

        // Left side status items
        Row {
            spacing: Theme.spacingXL

            // Language
            Row {
                spacing: Theme.spacingS
                Item {
                    width: 14
                    height: 14
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        id: langIcon
                        source: "qrc:/qt/qml/rapid_texter/assets/icons/globe.svg"
                        anchors.fill: parent
                        sourceSize: Qt.size(14, 14)
                        visible: false
                    }
                    ColorOverlay {
                        anchors.fill: langIcon
                        source: langIcon
                        color: Theme.accentBlue
                    }
                }
                Text {
                    text: "Lang:"
                    color: Theme.accentBlue
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeM
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: statusBar.currentLanguage.toUpperCase()
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeM
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Text {
                text: "|"
                color: Theme.borderSecondary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeM
            }

            // Time
            Row {
                spacing: Theme.spacingS
                Item {
                    width: 14
                    height: 14
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        id: timerIcon
                        source: "qrc:/qt/qml/rapid_texter/assets/icons/clock.svg"
                        anchors.fill: parent
                        sourceSize: Qt.size(14, 14)
                        visible: false
                    }
                    ColorOverlay {
                        anchors.fill: timerIcon
                        source: timerIcon
                        color: Theme.accentBlue
                    }
                }
                Text {
                    text: "Time:"
                    color: Theme.accentBlue
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeM
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: statusBar.currentTime
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeM
                    anchors.verticalCenter: parent.verticalCenter
                    visible: statusBar.currentTime !== "Infinity"
                }
                Item {
                    width: 14
                    height: 14
                    anchors.verticalCenter: parent.verticalCenter
                    visible: statusBar.currentTime === "Infinity"
                    Image {
                        id: infStatusIcon
                        source: "qrc:/qt/qml/rapid_texter/assets/icons/infinity.svg"
                        anchors.fill: parent
                        sourceSize: Qt.size(14, 14)
                        visible: false
                    }
                    ColorOverlay {
                        anchors.fill: infStatusIcon
                        source: infStatusIcon
                        color: Theme.textPrimary
                    }
                }
            }

            Text {
                text: "|"
                color: Theme.borderSecondary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeM
            }

            // Mode
            Row {
                spacing: Theme.spacingS
                Item {
                    width: 14
                    height: 14
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        id: modeIcon
                        source: "qrc:/qt/qml/rapid_texter/assets/icons/gamepad.svg"
                        anchors.fill: parent
                        sourceSize: Qt.size(14, 14)
                        visible: false
                    }
                    ColorOverlay {
                        anchors.fill: modeIcon
                        source: modeIcon
                        color: Theme.accentBlue
                    }
                }
                Text {
                    text: "Mode:"
                    color: Theme.accentBlue
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeM
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: statusBar.currentMode
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeM
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        // SFX Toggle
        Rectangle {
            Layout.preferredWidth: sfxRow.implicitWidth + Theme.paddingL * 2
            Layout.preferredHeight: parent.height - Theme.spacingM
            color: sfxMouse.containsMouse ? Theme.bgTertiary : "transparent"
            radius: 4

            Row {
                id: sfxRow
                anchors.centerIn: parent
                spacing: Theme.spacingS
                Item {
                    width: 14
                    height: 14
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        id: sfxIconOn
                        source: "qrc:/qt/qml/rapid_texter/assets/icons/volume-on.svg"
                        anchors.fill: parent
                        sourceSize: Qt.size(14, 14)
                        visible: false
                    }
                    Image {
                        id: sfxIconOff
                        source: "qrc:/qt/qml/rapid_texter/assets/icons/volume-off.svg"
                        anchors.fill: parent
                        sourceSize: Qt.size(14, 14)
                        visible: false
                    }
                    ColorOverlay {
                        anchors.fill: parent
                        source: statusBar.sfxEnabled ? sfxIconOn : sfxIconOff
                        color: statusBar.sfxEnabled ? Theme.accentBlue : Theme.accentRed
                    }
                }
                Text {
                    text: "SFX:"
                    color: Theme.accentBlue
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeM
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: statusBar.sfxEnabled ? "On" : "Off"
                    color: statusBar.sfxEnabled ? Theme.textPrimary : Theme.accentRed
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeM
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: sfxMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: statusBar.sfxToggled()
            }
        }
    }
}
