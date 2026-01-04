import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Rectangle {
    id: campaignMenuPage
    color: Theme.bgPrimary
    focus: true

    // Campaign progress state (passed from main window)
    property bool easyPassed: true
    property bool mediumPassed: false
    property bool hardPassed: false
    property bool programmerCertified: false

    // Navigation signals
    signal difficultySelected(string difficulty)
    signal creditsClicked
    signal resetClicked
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


