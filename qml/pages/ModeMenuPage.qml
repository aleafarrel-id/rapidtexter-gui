/**
 * @file ModeMenuPage.qml
 * @brief Game mode selection menu page.
 * @author RapidTexter Team
 * @date 2026
 *
 * Allows users to select the game mode:
 * - Manual [1]: Free practice without progression
 * - Campaign [2]: Progressive difficulty levels
 *
 * @section shortcuts Keyboard Shortcuts
 * - Key_1: Select Manual mode
 * - Key_2: Select Campaign mode
 * - Key_Escape: Go back
 */
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

/**
 * @brief Game mode selection page component.
 * @inherits Rectangle
 */
Rectangle {
    id: modeMenuPage
    color: Theme.bgPrimary
    focus: true

    /** @signal modeSelected @brief Emitted with selected mode ("Manual" or "Campaign"). */
    signal modeSelected(string mode)

    /** @signal backClicked @brief Emitted when user presses [ESC]. */
    signal backClicked

    Keys.onPressed: function (event) {
        switch (event.key) {
        case Qt.Key_1:
            modeSelected("Manual");
            event.accepted = true;
            break;
        case Qt.Key_2:
            modeSelected("Campaign");
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
        height: modeCol.implicitHeight

        ColumnLayout {
            id: modeCol
            anchors.fill: parent
            spacing: 0

            Text {
                Layout.fillWidth: true
                Layout.bottomMargin: 30
                text: "SELECT MODE"
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
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/hand.svg"
                    labelText: "Manual Mode"
                    onClicked: modeMenuPage.modeSelected("Manual")
                }
                MenuItemC {
                    keyText: "[2]"
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/trophy.svg"
                    labelText: "Campaign Mode"
                    onClicked: modeMenuPage.modeSelected("Campaign")
                }
            }

            Row {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 30
                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/arrow-left.svg"
                    labelText: "Back (ESC)"
                    onClicked: modeMenuPage.backClicked()
                }
            }
        }
    }
}
