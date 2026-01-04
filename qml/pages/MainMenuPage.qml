import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Rectangle {
    id: mainMenuPage
    color: Theme.bgPrimary
    focus: true

    // Navigation signals
    signal startGameClicked
    signal showHistoryClicked
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


