import QtQuick
import Qt5Compat.GraphicalEffects

Rectangle {
    id: navBtn

    // Public properties
    property string iconText: ""      // Deprecated: emoji fallback
    property string iconSource: ""    // SVG icon path
    property string labelText: "Button"
    property string variant: "default"  // "default", "primary", "danger", "reset", "yellow"

    signal clicked

    // Computed properties
    readonly property bool isHovered: navMouse.containsMouse
    readonly property color variantColor: {
        switch (variant) {
        case "primary":
            return Theme.accentGreen;
        case "danger":
            return Theme.accentRed;
        case "reset":
            return Theme.accentYellow;
        case "yellow":
            return Theme.accentYellow;
        default:
            return Theme.accentBlue;
        }
    }

    // Sizing
    implicitWidth: navRow.implicitWidth + Theme.paddingXL * 2
    implicitHeight: 36

    // Styling
    color: isHovered ? (variant === "default" ? Theme.bgSecondary : Qt.rgba(variantColor.r, variantColor.g, variantColor.b, 0.1)) : (variant === "primary" ? Theme.successBg : "transparent")
    border.width: 1
    border.color: isHovered ? variantColor : (variant !== "default" ? variantColor : Theme.borderSecondary)

    Row {
        id: navRow
        anchors.centerIn: parent
        spacing: Theme.spacingSM

        // SVG Icon with ColorOverlay
        Item {
            width: navBtn.iconSource !== "" ? 14 : 0
            height: 14
            anchors.verticalCenter: parent.verticalCenter

            Image {
                id: navIcon
                source: navBtn.iconSource
                anchors.fill: parent
                sourceSize: Qt.size(14, 14)
                visible: false
            }

            ColorOverlay {
                anchors.fill: navIcon
                source: navIcon
                color: navBtn.variantColor
                opacity: navBtn.isHovered ? 1.0 : 0.7
                visible: navBtn.iconSource !== ""
            }
        }

        // Fallback emoji icon (deprecated)
        Text {
            text: navBtn.iconText
            font.pixelSize: Theme.fontSizeSM
            visible: navBtn.iconText !== "" && navBtn.iconSource === ""
        }

        Text {
            text: navBtn.labelText
            color: navBtn.isHovered ? navBtn.variantColor : (navBtn.variant !== "default" ? navBtn.variantColor : Theme.textSecondary)
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeM
        }
    }

    MouseArea {
        id: navMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: navBtn.clicked()
    }
}

