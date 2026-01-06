/**
 * @file LanguageMenuPage.qml
 * @brief Language selection menu page.
 * @author RapidTexter Team
 * @date 2026
 *
 * Allows users to select the game language:
 * - Indonesia [1]: Indonesian word sets
 * - English [2]: English word sets
 *
 * @section shortcuts Keyboard Shortcuts
 * - Key_1: Select Indonesia
 * - Key_2: Select English
 * - Key_Escape: Go back
 */
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

/**
 * @brief Language selection page component.
 * @inherits Rectangle
 */
Rectangle {
    id: languageMenuPage
    color: Theme.bgPrimary
    focus: true

    /** @signal languageSelected @brief Emitted with selected language code ("ID" or "EN"). */
    signal languageSelected(string lang)

    /** @signal backClicked @brief Emitted when user presses [ESC]. */
    signal backClicked

    Keys.onPressed: function (event) {
        switch (event.key) {
        case Qt.Key_1:
            languageSelected("ID");
            event.accepted = true;
            break;
        case Qt.Key_2:
            languageSelected("EN");
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
        height: langCol.implicitHeight

        ColumnLayout {
            id: langCol
            anchors.fill: parent
            spacing: 0

            Text {
                Layout.fillWidth: true
                Layout.bottomMargin: 30
                text: "SELECT LANGUAGE"
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
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/globe.svg"
                    labelText: "Indonesia (ID)"
                    onClicked: languageMenuPage.languageSelected("ID")
                }
                MenuItemC {
                    keyText: "[2]"
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/globe.svg"
                    labelText: "English (EN)"
                    onClicked: languageMenuPage.languageSelected("EN")
                }
            }

            Row {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 30
                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/arrow-left.svg"
                    labelText: "Back (ESC)"
                    onClicked: languageMenuPage.backClicked()
                }
            }
        }
    }
}
