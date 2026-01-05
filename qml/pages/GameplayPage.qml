import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import rapid_texter
import "../components"

FocusScope {
    id: gameplayPage
    focus: true

    // Background
    Rectangle {
        anchors.fill: parent
        color: Theme.bgPrimary
        z: -100
    }

    // ========================================================================
    // PROPERTIES - Game State
    // ========================================================================

    // Target text to type (will be set by parent)
    property string targetText: "darah salah tidak mulut ada di situ berbunyi melihat sekali"

    // User's typed text - use list for better reactivity
    property var typedChars: []

    // Computed property for backward compatibility
    property string typedText: typedChars.join("")

    // Current cursor position - ALWAYS equals typedChars.length to prevent desync
    property int cursorPosition: typedChars.length

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
    property int totalKeystrokes: 0  // Every keystroke (not backspace)
    property real startTime: 0  // Timestamp when game started
    property bool gameEnded: false  // Prevent double gameCompleted signals

    // ========================================================================
    // SIGNALS
    // ========================================================================

    signal gameCompleted(int wpm, real accuracy, int errors, real timeElapsed)
    signal resetClicked
    signal exitClicked

    // ========================================================================
    // FUNCTIONS
    // ========================================================================

    // Split target text into words for proper wrapping
    property var words: targetText.split(" ")

    // Build word info array with start/end indices
    function buildWordInfo() {
        var result = [];
        var currentIndex = 0;
        for (var i = 0; i < words.length; i++) {
            result.push({
                word: words[i],
                startIndex: currentIndex,
                endIndex: currentIndex + words[i].length - 1
            });
            currentIndex += words[i].length + 1; // +1 for space
        }
        return result;
    }

    property var wordInfo: buildWordInfo()

    function getCharState(index) {
        if (index < cursorPosition) {
            // Already typed - check against typed array
            if (index < typedChars.length) {
                var typedChar = typedChars[index];
                var targetChar = targetText.charAt(index);
                if (typedChar === targetChar) {
                    return "correct";
                } else {
                    return "incorrect";
                }
            } else {
                return "pending";  // Cursor moved but no char typed (shouldn't happen)
            }
        } else if (index === cursorPosition) {
            return "current";
        } else {
            return "pending";
        }
    }

    // Find the start of the current word being typed
    function findCurrentWordStart() {
        for (var i = 0; i < wordInfo.length; i++) {
            if (cursorPosition >= wordInfo[i].startIndex && cursorPosition <= wordInfo[i].endIndex + 1) {
                return wordInfo[i].startIndex;
            }
        }
        return cursorPosition;
    }

    // Check if we can delete (can't delete previous correctly completed words)
    function canDeleteAtPosition() {
        if (cursorPosition <= 0)
            return false;

        // Calculate locked limit (matching TUI logic from GameEngine.cpp)
        var lockedLimit = 0;

        // Find the nearest checkpoint (previous word that's completely correct)
        for (var i = cursorPosition - 1; i >= 0; i--) {
            if (i < targetText.length && targetText.charAt(i) === " ") {
                // Found a space, check if everything up to this point is correct
                var allCorrect = true;
                if (i < typedChars.length) {
                    for (var k = 0; k <= i; k++) {
                        if (k >= typedChars.length || typedChars[k] !== targetText.charAt(k)) {
                            allCorrect = false;
                            break;
                        }
                    }
                    if (allCorrect) {
                        lockedLimit = i + 1;
                        break;
                    }
                }
            }
        }

        // Can only delete if above the lock limit
        return cursorPosition > lockedLimit;
    }

    // Calculate game results (matching original TUI logic from Stats.h)
    function calculateResults() {
        var elapsedSeconds = (Date.now() - startTime) / 1000;
        if (elapsedSeconds <= 0)
            elapsedSeconds = 1;  // Avoid division by zero

        // WPM = (correctKeystrokes / 5) / (time in minutes)
        // Standard: 5 characters = 1 word
        var wpm = (correctChars / 5) / (elapsedSeconds / 60);

        // Accuracy = correctKeystrokes / totalKeystrokes * 100 (per original Stats.h)
        var accuracy = totalKeystrokes > 0 ? (correctChars / totalKeystrokes) * 100 : 0;

        return {
            wpm: Math.round(wpm),
            accuracy: accuracy,
            timeElapsed: elapsedSeconds
        };
    }

    function processKey(key, text) {
        if (!gameStarted && text.length > 0) {
            gameStarted = true;
            startTime = Date.now();  // Record start time
        }

        // cursorPosition is computed from typedChars.length, so save current position before push
        var positionBeforePush = cursorPosition;

        if (text.length > 0 && positionBeforePush < targetText.length) {
            // Add character to array - this automatically updates cursorPosition
            var newTypedChars = typedChars.slice();  // Create copy
            newTypedChars.push(text);
            typedChars = newTypedChars;  // Trigger property change, cursorPosition now = length

            totalKeystrokes++;  // Count every keystroke (per original logic)

            // Compare against position BEFORE the push (not the new cursorPosition)
            if (text === targetText.charAt(positionBeforePush)) {
                correctChars++;
                // No sound on correct keystroke (per user request)
            } else {
                incorrectChars++;  // Errors - only increases, never decreases
                GameBackend.playErrorSound();    // Play SFX for incorrect keystroke
            }
            // NOTE: cursorPosition++ removed - it's now computed from typedChars.length

            // Check if completed (cursorPosition is already updated since we pushed)
            if (cursorPosition >= targetText.length && !gameEnded) {
                gameEnded = true;  // Prevent double firing
                var results = calculateResults();
                gameCompleted(results.wpm, results.accuracy, incorrectChars, results.timeElapsed);
            }
        }
    }

    function resetGame() {
        typedChars = [];  // Reset array - cursorPosition automatically becomes 0
        correctChars = 0;
        incorrectChars = 0;
        totalKeystrokes = 0;
        gameStarted = false;
        gameEnded = false;  // Reset the flag
        startTime = 0;
        timeRemaining = timeLimit;
    }

    // ========================================================================
    // KEY HANDLING
    // ========================================================================

    // Hidden input to capture text and trigger virtual keyboard
    TextInput {
        id: inputHandler
        visible: true  // Must be visible to receive focus
        opacity: 0     // Hide visually
        width: 0
        height: 0 // Minimize footprint
        focus: true    // Auto-focus handled by FocusScope delegation!
        enabled: true
        activeFocusOnTab: false // Avoid tab stealing focus accidentally

        // Keep focus (Backup)
        onFocusChanged: {
            if (!focus && StackView.status === StackView.Active) {
                // If we lose focus while active, try to grab it back
                forceActiveFocus();
            }
        }

        // Handle special keys
        Keys.onPressed: function (event) {
            if (event.key === Qt.Key_Tab) {
                resetGame();
                resetClicked();
                event.accepted = true;
            } else if (event.key === Qt.Key_Escape) {
                // resetGame() removed to prevent UI freeze/lag on exit (destruction handles cleanup)
                exitClicked();
                event.accepted = true;
            } else if (event.key === Qt.Key_Backspace) {
                if (canDeleteAtPosition()) {
                    // Remove last character from array - cursorPosition automatically decrements
                    var newTypedChars = typedChars.slice(0, -1);
                    typedChars = newTypedChars;
                    // NOTE: cursorPosition-- removed - it's computed from typedChars.length
                }
                event.accepted = true;
            }
        // Let normal text flow to onTextEdited
        }

        onTextEdited: {
            // Processing input character by character
            // We only care about the last character typed if it's an addition
            // But since we clear it immediately, 'text' is the new char

            if (text.length > 0) {
                // Iterate over all chars (in case of fast typing/paste)
                for (var i = 0; i < text.length; i++) {
                    var charCode = text[i];
                    if (charCode !== '\r' && charCode !== '\n') { // Ignore newlines
                        processKey(0, charCode);
                    }
                }
                // Clear input to keep it ready for next char
                text = "";
            }
        }
    }

    // Also try to focus on click
    MouseArea {
        anchors.fill: parent
        z: -10 // Background click
        onClicked: {
            inputHandler.forceActiveFocus();
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
                if (gameplayPage.timeRemaining === 0 && !gameplayPage.gameEnded) {
                    // Time's up!
                    gameplayPage.gameEnded = true;  // Prevent double firing
                    var results = gameplayPage.calculateResults();
                    gameplayPage.gameCompleted(results.wpm, results.accuracy, gameplayPage.incorrectChars, results.timeElapsed);
                }
            }
        }
    }

    // ========================================================================
    // UI LAYOUT
    // ========================================================================

    // Timer to poll CAPS LOCK state
    Timer {
        id: capsLockTimer
        interval: 200
        running: true
        repeat: true
        onTriggered: capsLockOn = GameBackend.isCapsLockOn()
    }

    Item {
        anchors.centerIn: parent
        width: Math.min(parent.width - Theme.paddingHuge * 2, 1000)
        height: gameCol.implicitHeight

        ColumnLayout {
            id: gameCol
            anchors.fill: parent
            spacing: 0

            // Timer Display Row
            RowLayout {
                Layout.fillWidth: true
                Layout.bottomMargin: 10
                spacing: Theme.spacingL

                // Timer Display
                Text {
                    Layout.leftMargin: 48
                    text: gameplayPage.timeRemaining >= 0 ? gameplayPage.timeRemaining : "∞"
                    color: Theme.accentBlue
                    font.family: Theme.fontFamily
                    font.pixelSize: 32
                    font.weight: Font.DemiBold
                }

                Item {
                    Layout.fillWidth: true
                }  // Spacer
            }

            // Text Display (borderless for clean monkeytype-like look)
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: textFlow.implicitHeight + 96
                color: "transparent"

                Flow {
                    id: textFlow
                    anchors.fill: parent
                    anchors.margins: 48
                    spacing: 0 // No horizontal gap, spaces are explicit

                    Repeater {
                        model: gameplayPage.wordInfo.length

                        // Each word is a Row that won't be broken
                        Row {
                            id: wordRow
                            spacing: 0
                            height: 48 // Font 28 + 20px vertical gap

                            property int wordIndex: index
                            property var wordData: gameplayPage.wordInfo[index]
                            // Space position is right after the word ends
                            property int spaceIndex: wordData.endIndex + 1

                            Repeater {
                                model: wordData.word.length

                                Text {
                                    id: charText

                                    property int globalIndex: wordData.startIndex + index
                                    property string charState: gameplayPage.getCharState(globalIndex)
                                    property string character: wordData.word[index]

                                    text: character
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 28
                                    font.letterSpacing: 0.5

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

                                    // Background for incorrect chars - fixed height
                                    Rectangle {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        height: charText.font.pixelSize + 8
                                        color: charText.charState === "incorrect" ? Qt.rgba(248 / 255, 81 / 255, 73 / 255, 0.15) : "transparent"
                                        z: -1
                                    }

                                    // Caret cursor (vertical bar)
                                    Rectangle {
                                        visible: charText.charState === "current"
                                        anchors.left: parent.left
                                        anchors.leftMargin: -1
                                        anchors.verticalCenter: parent.verticalCenter
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

                            // Space character after word (except for last word)
                            // Shows actual typed char when incorrect for better UX
                            Text {
                                id: spaceText
                                visible: wordRow.wordIndex < gameplayPage.wordInfo.length - 1

                                property int globalIndex: wordRow.spaceIndex
                                property string charState: gameplayPage.getCharState(globalIndex)
                                // Get the actual character typed at this position
                                property string typedChar: globalIndex < gameplayPage.typedChars.length ? gameplayPage.typedChars[globalIndex] : ""
                                // Show the typed char if incorrect, otherwise show space
                                property string displayChar: charState === "incorrect" && typedChar.length > 0 ? typedChar : " "

                                text: displayChar
                                font.family: Theme.fontFamily
                                font.pixelSize: 28
                                font.letterSpacing: 0.5

                                // Red color when incorrect
                                color: charState === "incorrect" ? Theme.accentRed : Theme.textMuted

                                // Background for incorrect space
                                Rectangle {
                                    visible: spaceText.charState === "incorrect"
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    height: 28 + 8
                                    color: Qt.rgba(248 / 255, 81 / 255, 73 / 255, 0.15)
                                    z: -1
                                }

                                // Caret cursor at space position
                                Rectangle {
                                    visible: spaceText.charState === "current"
                                    anchors.left: parent.left
                                    anchors.leftMargin: -1
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 2
                                    height: 28 + 6
                                    color: Theme.accentBlue

                                    SequentialAnimation on opacity {
                                        running: spaceText.charState === "current" && !gameplayPage.gameStarted
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
            }

            // CAPS LOCK Warning - compact, centered, no animation
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: capsLockOn ? capsLockBox.height + 16 : 0
                Layout.topMargin: capsLockOn ? 12 : 0
                visible: gameplayPage.capsLockOn

                Rectangle {
                    id: capsLockBox
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#3D2800"
                    border.color: Theme.accentYellow
                    border.width: 1
                    radius: 4
                    width: capsLockContent.implicitWidth + 20
                    height: capsLockContent.implicitHeight + 8

                    Text {
                        id: capsLockContent
                        anchors.centerIn: parent
                        text: "CAPS LOCK ON"
                        color: Theme.accentYellow
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeM
                        font.bold: true
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
