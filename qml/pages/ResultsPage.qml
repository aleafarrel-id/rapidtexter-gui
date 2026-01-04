import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"

Rectangle {
    id: resultsPage
    color: Theme.bgPrimary
    focus: true

    // Results data properties
    property int wpm: 84
    property int accuracy: 99
    property string timeElapsed: "15.0s"
    property int errors: 1
    property bool passed: true
    property string passMessage: "LEVEL PASSED!"
    property string passDescription: "Great job! You've achieved the requirements."

    // Navigation signals
    signal continueClicked
    signal historyClicked

    Keys.onPressed: function (event) {
        switch (event.key) {
        case Qt.Key_Return:
        case Qt.Key_Enter:
            continueClicked();
            event.accepted = true;
            break;
        case Qt.Key_H:
            historyClicked();
            event.accepted = true;
            break;
        case Qt.Key_Escape:
            continueClicked();
            event.accepted = true;
            break;
        }
    }

    Item {
        anchors.centerIn: parent
        width: Math.min(parent.width - Theme.paddingHuge * 2, Theme.maxContentWidth)
        height: resCol.implicitHeight

        ColumnLayout {
            id: resCol
            anchors.fill: parent
            spacing: 0

            Text {
                Layout.fillWidth: true
                Layout.bottomMargin: 30
                text: "RESULTS"
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeDisplay
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            // WPM Display
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                color: resultsPage.passed ? Theme.successBg : "transparent"
                border.width: 1
                border.color: Theme.borderPrimary

                Rectangle {
                    width: 3
                    height: parent.height
                    color: resultsPage.passed ? Theme.accentGreen : Theme.accentRed
                }

                Text {
                    anchors.centerIn: parent
                    text: resultsPage.wpm + " WPM"
                    color: resultsPage.passed ? Theme.accentGreen : Theme.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: 48
                    font.bold: true
                }
            }

            // Stats row
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: Theme.spacingL
                spacing: Theme.spacingL

                Repeater {
                    model: [
                        {
                            label: "ACCURACY",
                            value: resultsPage.accuracy + "%",
                            color: Theme.textPrimary
                        },
                        {
                            label: "TIME",
                            value: resultsPage.timeElapsed,
                            color: Theme.textPrimary
                        },
                        {
                            label: "ERRORS",
                            value: resultsPage.errors.toString(),
                            color: Theme.accentRed
                        }
                    ]

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        color: "transparent"
                        border.width: 1
                        border.color: Theme.borderPrimary

                        Rectangle {
                            width: 3
                            height: parent.height
                            color: Theme.borderSecondary
                        }

                        Column {
                            anchors.centerIn: parent
                            spacing: Theme.spacingS

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.label
                                color: Theme.textSecondary
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeS
                                font.letterSpacing: 1
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.value
                                color: modelData.color
                                font.family: Theme.fontFamily
                                font.pixelSize: 32
                                font.bold: true
                            }
                        }
                    }
                }
            }

            // Pass message
            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: 20
                Layout.preferredHeight: passCol.implicitHeight + 30
                color: resultsPage.passed ? Theme.successBg : "transparent"
                border.width: 1
                border.color: resultsPage.passed ? Theme.accentGreen : Theme.borderPrimary
                visible: resultsPage.passed

                Rectangle {
                    width: 3
                    height: parent.height
                    color: Theme.accentGreen
                }

                Column {
                    id: passCol
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "✓ " + resultsPage.passMessage
                        color: Theme.accentGreen
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeXXL
                        font.bold: true
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: resultsPage.passDescription
                        color: Theme.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeM
                    }
                }
            }

            Row {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 30
                spacing: Theme.spacingM
                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/arrow-right.svg"
                    labelText: "Continue (ENTER)"
                    variant: "primary"
                    onClicked: resultsPage.continueClicked()
                }
                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/history.svg"
                    labelText: "History (H)"
                    variant: "yellow"
                    onClicked: resultsPage.historyClicked()
                }
            }
        }
    }
}


