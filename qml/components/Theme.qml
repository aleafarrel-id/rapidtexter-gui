pragma Singleton
import QtQuick

QtObject {
    id: theme

    // Font loader reference - will be set from Main.qml
    property string fontFamily: "JetBrains Mono"

    // Background colors
    readonly property color bgPrimary: "#0d1117"
    readonly property color bgSecondary: "#161b22"
    readonly property color bgTertiary: "#21262d"

    // Border colors
    readonly property color borderPrimary: "#21262d"
    readonly property color borderSecondary: "#30363d"

    // Text colors
    readonly property color textPrimary: "#c9d1d9"
    readonly property color textSecondary: "#8b949e"
    readonly property color textMuted: "#484f58"

    // Accent colors
    readonly property color accentBlue: "#58a6ff"
    readonly property color accentGreen: "#3fb950"
    readonly property color accentYellow: "#d29922"
    readonly property color accentRed: "#f85149"

    // Status background colors
    readonly property color successBg: Qt.rgba(0.247, 0.725, 0.314, 0.1)
    readonly property color warningBg: Qt.rgba(0.824, 0.600, 0.133, 0.1)
    readonly property color dangerBg: Qt.rgba(0.973, 0.318, 0.286, 0.1)
    readonly property color infoBg: Qt.rgba(0.345, 0.651, 1.0, 0.1)

    // Font sizes
    readonly property int fontSizeS: 11
    readonly property int fontSizeSM: 12
    readonly property int fontSizeM: 13
    readonly property int fontSizeL: 14
    readonly property int fontSizeXL: 15
    readonly property int fontSizeXXL: 18
    readonly property int fontSizeDisplay: 24
    readonly property int fontSizeLogo: 64
    readonly property int fontSizeLogoSubtitle: 12

    // Spacing
    readonly property int spacingS: 6
    readonly property int spacingSM: 8
    readonly property int spacingM: 12
    readonly property int spacingL: 16
    readonly property int spacingXL: 20
    readonly property int spacingXXL: 24
    readonly property int spacingHuge: 32
    readonly property int spacingLogo: 50

    // Padding
    readonly property int paddingS: 6
    readonly property int paddingM: 10
    readonly property int paddingL: 14
    readonly property int paddingXL: 18
    readonly property int paddingXXL: 24
    readonly property int paddingHuge: 28

    // Component sizes
    readonly property int menuKeyMinWidth: 40
    readonly property int statusBarHeight: 40
    readonly property int maxContentWidth: 800

    // Animation
    readonly property int animationDuration: 150
}

