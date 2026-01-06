/**
 * @file MainMenuPage.qml
 * @brief Main menu page with navigation options for the RapidTexter application.
 * @author RapidTexter Team
 * @date 2026
 *
 * Displays the application logo and main navigation options:
 * - Start Game [1]: Begin a new typing game
 * - Show History [2]: View past game results
 * - Quit [Q]: Exit the application
 *
 * @section shortcuts Keyboard Shortcuts
 * - Key_1: Start game
 * - Key_2: Show history
 * - Key_Q: Quit application
 */
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

/**
 * @brief Main menu page component.
 * @inherits Rectangle
 */
Rectangle {
    id: mainMenuPage
    color: Theme.bgPrimary
    focus: true

    /* ========================================================================
     * NAVIGATION SIGNALS
     * ======================================================================== */

    /** @signal startGameClicked @brief Emitted when user presses [1] or clicks Start Game. */
    signal startGameClicked

    /** @signal showHistoryClicked @brief Emitted when user presses [2] or clicks Show History. */
    signal showHistoryClicked

    /** @signal quitClicked @brief Emitted when user presses [Q] or clicks Quit. */
    signal quitClicked

    Keys.onPressed: function (event) {
        switch (event.key) {
        case Qt.Key_1:
            startGameClicked();
            event.accepted = true;
            break;
        case Qt.Key_2:
            showHistoryClicked();
            event.accepted = true;
            break;
        case Qt.Key_Q:
            quitClicked();
            event.accepted = true;
            break;
        }
    }

    Item {
        anchors.centerIn: parent
        width: Math.min(parent.width - Theme.paddingHuge * 2, Theme.maxContentWidth)
        height: mainCol.implicitHeight

        ColumnLayout {
            id: mainCol
            anchors.fill: parent
            spacing: 0

            Column {
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: Theme.spacingLogo
                spacing: Theme.spacingM

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "RAPID"
                    color: Theme.accentBlue
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeLogo
                    font.bold: true
                    font.letterSpacing: -3
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "TEXTER"
                    color: Theme.textSecondary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeLogoSubtitle
                    font.bold: true
                    font.letterSpacing: 5
                    opacity: 0.7
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.topMargin: 30
                spacing: Theme.spacingSM

                MenuItemC {
                    keyText: "[1]"
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/play.svg"
                    labelText: "Start Game"
                    accentType: "green"
                    onClicked: mainMenuPage.startGameClicked()
                }
                MenuItemC {
                    keyText: "[2]"
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/history.svg"
                    labelText: "Show History"
                    accentType: "yellow"
                    onClicked: mainMenuPage.showHistoryClicked()
                }
                MenuItemC {
                    keyText: "(Q)"
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/close.svg"
                    labelText: "Quit"
                    accentType: "red"
                    onClicked: mainMenuPage.quitClicked()
                }
            }

            Text {
                Layout.fillWidth: true
                Layout.topMargin: 30
                text: "Press keys or click to navigate"
                color: Theme.textMuted
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSM
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
