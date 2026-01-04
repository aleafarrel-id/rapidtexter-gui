import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../components"

Rectangle {
    id: resetHistoryPage
    color: Theme.bgPrimary
    focus: true

    // Navigation signals
    signal confirmClicked
    signal cancelClicked

    Keys.onPressed: function (event) {
        switch (event.key) {
        case Qt.Key_Return:
        case Qt.Key_Enter:
            confirmClicked();
            event.accepted = true;
            break;
        case Qt.Key_Escape:
            cancelClicked();
            event.accepted = true;
            break;
        }
    }

    Item {
        anchors.centerIn: parent
        width: Math.min(parent.width - Theme.paddingHuge * 2, Theme.maxContentWidth)
        height: rhCol.implicitHeight

        ColumnLayout {
            id: rhCol
            anchors.fill: parent
            spacing: 0

            Text {
                Layout.fillWidth: true
                Layout.bottomMargin: 30
                text: "CLEAR HISTORY"
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeDisplay
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: rhConfirmCol.implicitHeight + 60
                color: Theme.dangerBg
                border.width: 1
                border.color: Theme.accentRed

                Rectangle {
                    width: 3
                    height: parent.height
                    color: Theme.accentRed
                }

                Column {
                    id: rhConfirmCol
                    anchors.centerIn: parent
                    spacing: Theme.spacingL

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Are you sure?"
                        color: Theme.accentRed
                        font.family: Theme.fontFamily
                        font.pixelSize: 18
                        font.bold: true
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "This will permanently delete all your game history."
                        color: Theme.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeL
                    }
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: Theme.spacingS
                        Item {
                            width: 14
                            height: 14
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                id: warningIcon
                                source: "qrc:/qt/qml/rapid_texter/assets/icons/warning.svg"
                                anchors.fill: parent
                                sourceSize: Qt.size(14, 14)
                                visible: false
                            }
                            ColorOverlay {
                                anchors.fill: warningIcon
                                source: warningIcon
                                color: Theme.accentYellow
                            }
                        }
                        Text {
                            text: "This action cannot be undone"
                            color: Theme.accentYellow
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSM
                        }
                    }
                }
            }

            Row {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 30
                spacing: Theme.spacingM
                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/arrow-left.svg"
                    labelText: "Cancel (ESC)"
                    onClicked: resetHistoryPage.cancelClicked()
                }
                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/trash.svg"
                    labelText: "Confirm (ENTER)"
                    variant: "danger"
                    onClicked: resetHistoryPage.confirmClicked()
                }
            }
        }
    }
}


