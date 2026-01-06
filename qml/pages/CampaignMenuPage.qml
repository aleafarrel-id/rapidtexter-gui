/**
 * @file CampaignMenuPage.qml
 * @brief Campaign difficulty selection menu with progressive unlocking.
 * @author RapidTexter Team
 * @date 2026
 *
 * Displays campaign levels with progression:
 * - Easy [1]: Base level (Min: 40 WPM, 80% Acc)
 * - Medium [2]: Locked until Easy passed (Min: 60 WPM, 85% Acc)
 * - Hard [3]: Locked until Medium passed (Min: 80 WPM, 90% Acc)
 * - Programmer [4]: Special challenge level
 *
 * @section shortcuts Keyboard Shortcuts
 * - Key_1 to Key_4: Select difficulty (if unlocked)
 * - Key_C: View credits
 * - Key_R: Reset progress
 * - Key_Escape: Go back
 */
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

/**
 * @brief Campaign difficulty selection page with unlock progression.
 * @inherits Rectangle
 */
Rectangle {
    id: campaignMenuPage
    color: Theme.bgPrimary
    focus: true

    /* ========================================================================
     * CAMPAIGN PROGRESS STATE
     * ======================================================================== */

    /** @property easyPassed @brief Whether Easy level has been completed. */
    property bool easyPassed: true

    /** @property mediumPassed @brief Whether Medium level has been completed. */
    property bool mediumPassed: false

    /** @property hardPassed @brief Whether Hard level has been completed. */
    property bool hardPassed: false

    /** @property programmerCertified @brief Whether Programmer challenge is completed. */
    property bool programmerCertified: false

    /* ========================================================================
     * NAVIGATION SIGNALS
     * ======================================================================== */

    /** @signal difficultySelected @brief Emitted with selected difficulty string. */
    signal difficultySelected(string difficulty)

    /** @signal creditsClicked @brief Emitted when user presses [C]. */
    signal creditsClicked

    /** @signal resetClicked @brief Emitted when user presses [R]. */
    signal resetClicked

    /** @signal backClicked @brief Emitted when user presses [ESC]. */
    signal backClicked

    Keys.onPressed: function (event) {
        switch (event.key) {
        case Qt.Key_1:
            difficultySelected("easy");
            event.accepted = true;
            break;
        case Qt.Key_2:
            if (easyPassed)
                difficultySelected("medium");
            event.accepted = true;
            break;
        case Qt.Key_3:
            if (mediumPassed)
                difficultySelected("hard");
            event.accepted = true;
            break;
        case Qt.Key_4:
            difficultySelected("programmer");
            event.accepted = true;
            break;
        case Qt.Key_C:
            creditsClicked();
            event.accepted = true;
            break;
        case Qt.Key_R:
            resetClicked();
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
        height: campCol.implicitHeight

        ColumnLayout {
            id: campCol
            anchors.fill: parent
            spacing: 0

            Text {
                Layout.fillWidth: true
                Layout.bottomMargin: 30
                text: "CAMPAIGN DIFFICULTY"
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
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/leaf.svg"
                    labelText: "Easy"
                    accentType: campaignMenuPage.easyPassed ? "green" : "default"
                    statusText: campaignMenuPage.easyPassed ? "[PASSED]" : ""
                    statusType: campaignMenuPage.easyPassed ? "passed" : ""
                    reqText: "Min: 40 WPM, 80% Acc"
                    onClicked: campaignMenuPage.difficultySelected("easy")
                }
                MenuItemC {
                    keyText: "[2]"
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/trend-up.svg"
                    labelText: "Medium"
                    locked: !campaignMenuPage.easyPassed
                    accentType: campaignMenuPage.mediumPassed ? "green" : "default"
                    statusText: campaignMenuPage.mediumPassed ? "[PASSED]" : (campaignMenuPage.easyPassed ? "" : "[LOCKED]")
                    statusType: campaignMenuPage.mediumPassed ? "passed" : (campaignMenuPage.easyPassed ? "" : "locked")
                    reqText: campaignMenuPage.easyPassed ? "Min: 60 WPM, 90% Acc" : "Need: Easy passed"
                    onClicked: if (campaignMenuPage.easyPassed)
                        campaignMenuPage.difficultySelected("medium")
                }
                MenuItemC {
                    keyText: "[3]"
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/fire.svg"
                    labelText: "Hard"
                    locked: !campaignMenuPage.mediumPassed
                    accentType: campaignMenuPage.hardPassed ? "green" : "default"
                    statusText: campaignMenuPage.hardPassed ? "[PASSED]" : (campaignMenuPage.mediumPassed ? "" : "[LOCKED]")
                    statusType: campaignMenuPage.hardPassed ? "passed" : (campaignMenuPage.mediumPassed ? "" : "locked")
                    reqText: campaignMenuPage.mediumPassed ? "Min: 70 WPM, 90% Acc" : "Need: Medium passed"
                    onClicked: if (campaignMenuPage.mediumPassed)
                        campaignMenuPage.difficultySelected("hard")
                }
                MenuItemC {
                    keyText: "[4]"
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/monitor.svg"
                    labelText: "Programmer Mode"
                    statusText: campaignMenuPage.programmerCertified ? "[CERTIFIED]" : "[AVAILABLE]"
                    statusType: "certified"
                    reqText: "50 WPM, 90% for Cert"
                    onClicked: campaignMenuPage.difficultySelected("programmer")
                }
            }

            Row {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 30
                spacing: Theme.spacingM
                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/arrow-left.svg"
                    labelText: "Back (ESC)"
                    onClicked: campaignMenuPage.backClicked()
                }
                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/users.svg"
                    labelText: "Credits (C)"
                    onClicked: campaignMenuPage.creditsClicked()
                }
                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/refresh.svg"
                    labelText: "Reset (R)"
                    variant: "danger"
                    onClicked: campaignMenuPage.resetClicked()
                }
            }
        }
    }
}
