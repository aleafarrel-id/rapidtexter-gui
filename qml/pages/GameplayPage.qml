import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../components"

Rectangle {
    id: gameplayPage
    color: Theme.bgPrimary
    focus: true

    // ========================================================================
    // PROPERTIES - Game State
    // ========================================================================

    // Target text to type (will be set by parent)
    property string targetText: "darah salah tidak mulut ada di situ berbunyi melihat sekali"

    // User's typed text
    property string typedText: ""

    // Current cursor position
    property int cursorPosition: 0

    // Time remaining (seconds), -1 for unlimited
    property int timeRemaining: 15

    // Time limit (for display)
    property int timeLimit: 15

    // Is game started?
    property bool gameStarted: false

    // Is caps lock on?
    property bool capsLockOn: false

    // Game statistics
    property int correctChars: 0
    property int incorrectChars: 0

    // ========================================================================
    // SIGNALS
    // ========================================================================

    signal gameCompleted(int wpm, real accuracy, int errors, real timeElapsed)
    signal resetClicked
    signal exitClicked

    // ========================================================================
    // FUNCTIONS
    // ========================================================================

    function getCharState(index) {
        if (index < cursorPosition) {
            // Already typed
            if (index < typedText.length && typedText[index] === targetText[index]) {
                return "correct";
            } else {
                return "incorrect";
            }
        } else if (index === cursorPosition) {
            return "current";
        } else {
            return "pending";
        }
    }

    function processKey(key, text) {
        if (!gameStarted && text.length > 0) {
            gameStarted = true;
        }

        if (text.length > 0 && cursorPosition < targetText.length) {
            typedText += text;
            if (text === targetText[cursorPosition]) {
                correctChars++;
            } else {
                incorrectChars++;
            }
            cursorPosition++;

            // Check if completed
            if (cursorPosition >= targetText.length) {
                gameCompleted(0, 0, incorrectChars, 0);
            }
        }
    }

    function resetGame() {
        typedText = "";
        cursorPosition = 0;
        correctChars = 0;
        incorrectChars = 0;
        gameStarted = false;
        timeRemaining = timeLimit;
    }

    // ========================================================================
    // KEY HANDLING
    // ========================================================================

    Keys.onPressed: function (event) {
        // Check for caps lock (Qt doesn't have direct caps lock detection, we check if shift+letter doesn't match case)

        if (event.key === Qt.Key_Tab) {
            resetGame();
            resetClicked();
            event.accepted = true;
        } else if (event.key === Qt.Key_Escape) {
            exitClicked();
            event.accepted = true;
        } else if (event.key === Qt.Key_Backspace) {
            // Optional: handle backspace
            event.accepted = true;
        } else if (event.text.length > 0 && event.key !== Qt.Key_Return && event.key !== Qt.Key_Enter) {
            processKey(event.key, event.text);
            event.accepted = true;
        }
    }

    // ========================================================================
    // TIMER
    // ========================================================================

    Timer {
        id: gameTimer
        interval: 1000
        running: gameplayPage.gameStarted && gameplayPage.timeRemaining > 0
        repeat: true
        onTriggered: {
            if (gameplayPage.timeRemaining > 0) {
                gameplayPage.timeRemaining--;
                if (gameplayPage.timeRemaining === 0) {
                    // Time's up!
                    gameplayPage.gameCompleted(0, 0, gameplayPage.incorrectChars, gameplayPage.timeLimit);
                }
            }
        }
    }

    // ========================================================================
    // UI LAYOUT
    // ========================================================================

    Item {
        anchors.centerIn: parent
        width: Math.min(parent.width - Theme.paddingHuge * 2, 1000)
        height: gameCol.implicitHeight

        ColumnLayout {
            id: gameCol
            anchors.fill: parent
            spacing: 0

            // Timer Display
            // Timer Display
            Text {
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: 48
                Layout.bottomMargin: 10
                text: gameplayPage.timeRemaining >= 0 ? gameplayPage.timeRemaining : "∞"
                color: Theme.accentBlue
                font.family: Theme.fontFamily
                font.pixelSize: 32
                font.weight: Font.DemiBold
            }

            // Text Display
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: textFlow.implicitHeight + 96
                color: "transparent"
                border.width: 1
                border.color: Theme.borderPrimary

                Rectangle {
                    width: 3
                    height: parent.height
                    color: Theme.borderSecondary
                }

                Flow {
                    id: textFlow
                    anchors.fill: parent
                    anchors.margins: 48
                    spacing: 0

                    Repeater {
                        model: gameplayPage.targetText.length

                        Text {
                            id: charText

                            property string charState: gameplayPage.getCharState(index)
                            property string character: gameplayPage.targetText[index]

                            text: character
                            font.family: Theme.fontFamily
                            font.pixelSize: 28
                            font.letterSpacing: 0.5
                            lineHeight: 1.6

                            color: {
                                switch (charState) {
                                case "correct":
                                    return Theme.textPrimary;
                                case "incorrect":
                                    return Theme.accentRed;
                                case "current":
                                    return Theme.textMuted;
                                case "pending":
                                default:
                                    return Theme.textMuted;
                                }
                            }

                            // Background for incorrect chars
                            Rectangle {
                                anchors.fill: parent
                                color: charText.charState === "incorrect" ? Qt.rgba(248 / 255, 81 / 255, 73 / 255, 0.15) : "transparent"
                                z: -1
                            }

                            // Underline for current char
                            // Caret cursor (vertical bar)
                            Rectangle {
                                visible: charText.charState === "current"
                                anchors.left: parent.left
                                anchors.leftMargin: -1
                                anchors.bottom: parent.baseline
                                anchors.bottomMargin: -6
                                width: 2
                                height: charText.font.pixelSize + 6
                                color: Theme.accentBlue

                                SequentialAnimation on opacity {
                                    running: charText.charState === "current" && !gameplayPage.gameStarted
                                    loops: Animation.Infinite
                                    NumberAnimation {
                                        to: 0
                                        duration: 500
                                    }
                                    NumberAnimation {
                                        to: 1
                                        duration: 500
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Caps Lock Warning
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: capsLockOn ? 44 : 0
                Layout.topMargin: capsLockOn ? 20 : 0
                visible: gameplayPage.capsLockOn
                color: Theme.warningBg
                border.width: 1
                border.color: Theme.accentYellow

                Rectangle {
                    width: 3
                    height: parent.height
                    color: Theme.accentYellow
                }

                Text {
                    anchors.centerIn: parent
                    text: "CAPS LOCK ON"
                    color: Theme.accentYellow
                    font.family: Theme.fontFamily
                    font.pixelSize: 14
                }

                Behavior on Layout.preferredHeight {
                    NumberAnimation {
                        duration: 150
                    }
                }
            }

            // Statistics Row (optional - shows during gameplay)
            Row {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                spacing: Theme.spacingXL
                visible: gameplayPage.gameStarted

                Row {
                    spacing: Theme.spacingS
                    Text {
                        text: "Correct:"
                        color: Theme.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeM
                    }
                    Text {
                        text: gameplayPage.correctChars
                        color: Theme.accentGreen
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeM
                        font.bold: true
                    }
                }

                Row {
                    spacing: Theme.spacingS
                    Text {
                        text: "Errors:"
                        color: Theme.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeM
                    }
                    Text {
                        text: gameplayPage.incorrectChars
                        color: Theme.accentRed
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeM
                        font.bold: true
                    }
                }
            }

            // Navigation Buttons
            Row {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 40
                spacing: Theme.spacingM

                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/refresh.svg"
                    labelText: "Reset (TAB)"
                    variant: "yellow"
                    onClicked: {
                        gameplayPage.resetGame();
                        gameplayPage.resetClicked();
                    }
                }

                NavBtn {
                    iconSource: "qrc:/qt/qml/rapid_texter/assets/icons/close.svg"
                    labelText: "Exit (ESC)"
                    onClicked: gameplayPage.exitClicked()
                }
            }

            // Instruction hint
            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                text: gameplayPage.gameStarted ? "Keep typing..." : "Start typing to begin!"
                color: Theme.textMuted
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSM
            }
        }
    }
}
