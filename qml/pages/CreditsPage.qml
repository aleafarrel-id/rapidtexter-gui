import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../components"

Rectangle {
    id: creditsPage
    color: Theme.bgPrimary
    focus: true

    // Developer credits
    property var developers: ["Alea Farrel", "Hensa Katelu", "Yanuar Adi Candra", "Arif Wibowo P.", "Aria Mahendra U."]

    // Navigation signal
    signal returnClicked

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Escape) {
            returnClicked();
            event.accepted = true;
        }
    }

    Item {
        anchors.centerIn: parent
        width: Math.min(parent.width - Theme.paddingHuge * 2, Theme.maxContentWidth)
        height: credCol.implicitHeight

        ColumnLayout {
            id: credCol
            anchors.fill: parent
            spacing: 0

            Text {
                Layout.fillWidth: true
                Layout.bottomMargin: 30
                text: "CREDITS"
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeDisplay
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                Layout.fillWidth: true
                Layout.bottomMargin: 20
                text: "DEVELOPED BY:"
                color: Theme.textSecondary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeL
                font.letterSpacing: 1
                horizontalAlignment: Text.AlignHCenter
            }

            Column {
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.spacingL

                Repeater {
                    model: creditsPage.developers
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData
                        color: Theme.accentBlue
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeXXL
                        font.bold: true
                    }
                }
            }

            Row {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 40
                spacing: Theme.spacingS
                Item {
                    width: 16
                    height: 16
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        id: heartIcon
                        source: "qrc:/qt/qml/rapid_texter/assets/icons/heart.svg"
                        anchors.fill: parent
                        sourceSize: Qt.size(16, 16)
                        visible: false
                    }
                    ColorOverlay {
                        anchors.fill: heartIcon
                        source: heartIcon
                        color: Theme.accentGreen
                    }
                }
                Text {
                    text: "Thank you for playing!"
                    color: Theme.accentGreen
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeL
                }
            }

            Row {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 40
                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/arrow-left.svg"
                    labelText: "Return (ENTER)"
                    onClicked: creditsPage.returnClicked()
                }
            }
        }
    }
}


