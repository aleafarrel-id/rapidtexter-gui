/**
 * @file CustomDurationPage.qml
 * @brief Custom game duration input page.
 * @author RapidTexter Team
 * @date 2026
 *
 * Allows users to enter a custom duration (5-600 seconds).
 * Features a text input with integer validation.
 *
 * @section shortcuts Keyboard Shortcuts
 * - Key_Return/Key_Enter: Confirm duration
 * - Key_Escape: Go back
 */
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

/**
 * @brief Custom duration input page component.
 * @inherits Rectangle
 */
Rectangle {
    id: customDurationPage
    color: Theme.bgPrimary
    focus: true

    /** @signal durationConfirmed @brief Emitted with custom duration string (e.g., "45s"). */
    signal durationConfirmed(string duration)

    /** @signal backClicked @brief Emitted when user presses [ESC]. */
    signal backClicked

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            var seconds = parseInt(customDurInput.text) || 30;
            durationConfirmed(seconds + "s");
            event.accepted = true;
        } else if (event.key === Qt.Key_Escape) {
            backClicked();
            event.accepted = true;
        }
    }

    Item {
        anchors.centerIn: parent
        width: Math.min(parent.width - Theme.paddingHuge * 2, Theme.maxContentWidth)
        height: customDurCol.implicitHeight

        ColumnLayout {
            id: customDurCol
            anchors.fill: parent
            spacing: 0

            Text {
                Layout.fillWidth: true
                Layout.bottomMargin: 30
                text: "CUSTOM DURATION"
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
                    text: "Enter Duration (seconds):"
                    color: Theme.textSecondary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeL
                }

                Rectangle {
                    width: parent.width
                    height: 50
                    color: Theme.bgPrimary
                    border.width: 1
                    border.color: customDurInput.activeFocus ? Theme.accentBlue : Theme.borderSecondary

                    TextInput {
                        id: customDurInput
                        anchors.fill: parent
                        anchors.margins: Theme.paddingL
                        text: "45"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeXXL
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        validator: IntValidator {
                            bottom: 5
                            top: 600
                        }
                        selectByMouse: true
                        Component.onCompleted: forceActiveFocus()
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.paddingL
                        anchors.verticalCenter: parent.verticalCenter
                        text: "SEC"
                        color: Theme.textMuted
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeM
                    }
                }

                Text {
                    text: "Valid range: 5 - 600 seconds"
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
                    onClicked: customDurationPage.backClicked()
                }
                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/arrow-right.svg"
                    labelText: "Confirm (ENTER)"
                    variant: "primary"
                    onClicked: {
                        var seconds = parseInt(customDurInput.text) || 30;
                        customDurationPage.durationConfirmed(seconds + "s");
                    }
                }
            }
        }
    }
}
