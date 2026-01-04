import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Rectangle {
    id: menuItem

    // Public properties
    property string keyText: "[1]"
    property string iconSource: ""
    property string labelText: "Menu Item"
    property string accentType: "default"  // "default", "green", "yellow", "red"
    property bool locked: false
    property string statusText: ""  // e.g. "[PASSED]", "[LOCKED]", "[AVAILABLE]"
    property string statusType: ""  // "passed", "locked", "certified"
    property string reqText: ""     // e.g. "Min: 40 WPM, 80% Acc"

    signal clicked

    // Computed properties
    readonly property color hoverColor: {
        if (locked)
            return Theme.borderSecondary;
        switch (accentType) {
        case "green":
            return Theme.accentGreen;
        case "yellow":
            return Theme.accentYellow;
        case "red":
            return Theme.accentRed;
        default:
            return Theme.accentBlue;
        }
    }
    readonly property bool isHovered: itemMouse.containsMouse && !locked

    // Layout
    Layout.fillWidth: true
    height: 70
    color: isHovered ? Theme.bgSecondary : "transparent"
    opacity: locked ? 0.5 : 1.0
    border.width: 1
    border.color: Theme.borderPrimary

    // Left accent bar
    Rectangle {
        width: 3
        height: parent.height
        color: menuItem.isHovered ? menuItem.hoverColor : Theme.borderSecondary
    }

    // Hover animation
    transform: Translate {
        x: menuItem.isHovered ? 4 : 0
        Behavior on x {
            NumberAnimation {
                duration: 150
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.paddingXXL
        anchors.rightMargin: Theme.paddingXXL
        spacing: Theme.spacingL

        // Key badge
        Rectangle {
            Layout.preferredWidth: Math.max(Theme.menuKeyMinWidth, keyLbl.implicitWidth + Theme.paddingL * 2)
            Layout.preferredHeight: 26
            color: menuItem.isHovered ? Theme.borderSecondary : Theme.bgTertiary
            border.width: 1
            border.color: Theme.borderSecondary

            Text {
                id: keyLbl
                anchors.centerIn: parent
                text: menuItem.keyText
                color: menuItem.isHovered ? Theme.textPrimary : Theme.textSecondary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeM
                font.bold: true
            }
        }

        // Icon and label
        Row {
            Layout.fillWidth: true
            spacing: Theme.spacingM

            Item {
                width: menuItem.iconSource !== "" ? 18 : 0
                height: 18
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: menuIcon
                    source: menuItem.iconSource
                    anchors.fill: parent
                    sourceSize: Qt.size(18, 18)
                    visible: false
                }

                ColorOverlay {
                    anchors.fill: menuIcon
                    source: menuIcon
                    color: menuItem.hoverColor
                    visible: menuItem.iconSource !== ""
                    opacity: menuItem.isHovered ? 1.0 : 0.7
                }
            }

            Text {
                text: menuItem.labelText
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeXL
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Status badge and requirement info (for campaign levels)
        Column {
            visible: menuItem.statusText !== "" || menuItem.reqText !== ""
            spacing: 4
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                visible: menuItem.statusText !== ""
                anchors.right: parent.right
                width: statusLabel.implicitWidth + Theme.paddingM * 2
                height: 22
                color: {
                    switch (menuItem.statusType) {
                    case "passed":
                        return Qt.rgba(0.247, 0.725, 0.314, 0.1);
                    case "locked":
                        return Qt.rgba(0.973, 0.318, 0.286, 0.1);
                    case "certified":
                        return Qt.rgba(0.345, 0.651, 1.0, 0.1);
                    default:
                        return "transparent";
                    }
                }
                border.width: 1
                border.color: {
                    switch (menuItem.statusType) {
                    case "passed":
                        return Theme.accentGreen;
                    case "locked":
                        return Theme.accentRed;
                    case "certified":
                        return Theme.accentBlue;
                    default:
                        return Theme.borderSecondary;
                    }
                }

                Text {
                    id: statusLabel
                    anchors.centerIn: parent
                    text: menuItem.statusText
                    color: {
                        switch (menuItem.statusType) {
                        case "passed":
                            return Theme.accentGreen;
                        case "locked":
                            return Theme.accentRed;
                        case "certified":
                            return Theme.accentBlue;
                        default:
                            return Theme.textSecondary;
                        }
                    }
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeS
                    font.bold: true
                    font.letterSpacing: 0.5
                }
            }

            Text {
                visible: menuItem.reqText !== ""
                anchors.right: parent.right
                text: menuItem.reqText
                color: Theme.textMuted
                font.family: Theme.fontFamily
                font.pixelSize: 10
            }
        }
    }

    MouseArea {
        id: itemMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: locked ? Qt.ForbiddenCursor : Qt.PointingHandCursor
        onClicked: if (!menuItem.locked)
            menuItem.clicked()
    }
}

