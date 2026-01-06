/**
 * @file DurationMenuPage.qml
 * @brief Game duration selection menu page.
 * @author RapidTexter Team
 * @date 2026
 *
 * Allows users to select the typing test duration:
 * - 15 seconds [1]
 * - 30 seconds [2]
 * - 60 seconds [3]
 * - Custom duration [4]
 * - Infinity [5] (no time limit)
 *
 * @section shortcuts Keyboard Shortcuts
 * - Key_1 to Key_5: Select corresponding duration
 * - Key_Escape: Go back
 */
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import rapid_texter 1.0
import "../components"

/**
 * @brief Duration selection page component.
 * @inherits Rectangle
 */
Rectangle {
    id: durationMenuPage
    color: Theme.bgPrimary
    focus: true

    /** @signal durationSelected @brief Emitted with selected duration string. */
    signal durationSelected(string duration)

    /** @signal customDurationClicked @brief Emitted when user selects custom option. */
    signal customDurationClicked

    /** @signal backClicked @brief Emitted when user presses [ESC]. */
    signal backClicked

    Keys.onPressed: function (event) {
        switch (event.key) {
        case Qt.Key_1:
            durationSelected("15s");
            event.accepted = true;
            break;
        case Qt.Key_2:
            durationSelected("30s");
            event.accepted = true;
            break;
        case Qt.Key_3:
            durationSelected("60s");
            event.accepted = true;
            break;
        case Qt.Key_4:
            customDurationClicked();
            event.accepted = true;
            break;
        case Qt.Key_5:
            durationSelected("Infinity");
            event.accepted = true;
            break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
            durationSelected(GameBackend.defaultDuration === -1 ? "Infinity" : GameBackend.defaultDuration + "s");
            event.accepted = true;
            break;
        case Qt.Key_Escape:
            backClicked();
            event.accepted = true;
            break;
        }
    }

    Item {
        anchors.centerIn: parent
        width: Math.min(parent.width - Theme.paddingHuge * 2, Theme.maxContentWidth)
        height: durCol.implicitHeight

        ColumnLayout {
            id: durCol
            anchors.fill: parent
            spacing: 0

            Text {
                Layout.fillWidth: true
                Layout.bottomMargin: 30
                text: "SELECT DURATION"
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeDisplay
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingSM

                MenuItemC {
                    keyText: "[1]"
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/clock.svg"
                    labelText: "15 Seconds"
                    onClicked: durationMenuPage.durationSelected("15s")
                }
                MenuItemC {
                    keyText: "[2]"
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/clock.svg"
                    labelText: "30 Seconds"
                    onClicked: durationMenuPage.durationSelected("30s")
                }
                MenuItemC {
                    keyText: "[3]"
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/clock.svg"
                    labelText: "60 Seconds"
                    onClicked: durationMenuPage.durationSelected("60s")
                }
                MenuItemC {
                    keyText: "[4]"
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/sliders.svg"
                    labelText: "Custom"
                    accentType: "yellow"
                    onClicked: durationMenuPage.customDurationClicked()
                }
                MenuItemC {
                    keyText: "[5]"
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/infinity.svg"
                    labelText: "Infinity (No Limit)"
                    onClicked: durationMenuPage.durationSelected("Infinity")
                }
            }

            Text {
                Layout.fillWidth: true
                Layout.topMargin: 15
                text: "[Enter] Use Default (" + (GameBackend.defaultDuration === -1 ? "∞" : GameBackend.defaultDuration + "s") + ")"
                color: Theme.accentGreen
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeM
                horizontalAlignment: Text.AlignHCenter
            }

            Row {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 30
                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/arrow-left.svg"
                    labelText: "Back (ESC)"
                    onClicked: durationMenuPage.backClicked()
                }
            }
        }
    }
}
