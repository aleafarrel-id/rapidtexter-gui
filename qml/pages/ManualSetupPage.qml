import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Rectangle {
    id: manualSetupPage
    color: Theme.bgPrimary
    focus: true

    property int targetWpm: 60

    // Navigation signals
    signal startClicked(int wpm)
    signal backClicked

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            startClicked(parseInt(wpmInput.text) || 60);
            event.accepted = true;
        } else if (event.key === Qt.Key_Escape) {
            backClicked();
            event.accepted = true;
        }
    }

    Item {
        anchors.centerIn: parent
        width: Math.min(parent.width - Theme.paddingHuge * 2, Theme.maxContentWidth)
        height: setupCol.implicitHeight

        ColumnLayout {
            id: setupCol
            anchors.fill: parent
            spacing: 0

            Text {
                Layout.fillWidth: true
                Layout.bottomMargin: 30
                text: "MANUAL SETUP"
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeDisplay
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            Column {
                Layout.fillWidth: true
                spacing: Theme.spacingM

                Text {
                    text: "Enter Target WPM:"
                    color: Theme.textSecondary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeL
                }

                Rectangle {
                    width: parent.width
                    height: 50
                    color: Theme.bgPrimary
                    border.width: 1
                    border.color: wpmInput.activeFocus ? Theme.accentBlue : Theme.borderSecondary

                    TextInput {
                        id: wpmInput
                        anchors.fill: parent
                        anchors.margins: Theme.paddingL
                        text: "60"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeXXL
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        validator: IntValidator {
                            bottom: 1
                            top: 200
                        }
                        selectByMouse: true
                        Component.onCompleted: forceActiveFocus()
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.paddingL
                        anchors.verticalCenter: parent.verticalCenter
                        text: "WPM"
                        color: Theme.textMuted
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeM
                    }
                }

                Text {
                    text: "Valid range: 1 - 200 WPM"
                    color: Theme.textMuted
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSM
                }
            }

            Row {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 30
                spacing: Theme.spacingM
                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/arrow-left.svg"
                    labelText: "Back (ESC)"
                    onClicked: manualSetupPage.backClicked()
                }
                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/arrow-right.svg"
                    labelText: "Confirm (ENTER)"
                    variant: "primary"
                    onClicked: manualSetupPage.startClicked(parseInt(wpmInput.text) || 60)
                }
            }
        }
    }
}


