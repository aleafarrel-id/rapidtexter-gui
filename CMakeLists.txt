cmake_minimum_required(VERSION 3.16)

project(RapidTexterGUI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.8)
qt_policy(SET QTP0004 OLD)

qt_add_executable(RapidTexterGUI
    main.cpp
)

# Mark Theme.qml as a singleton
set_source_files_properties(qml/components/Theme.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(RapidTexterGUI
    URI rapid_texter
    VERSION 1.0
    QML_FILES
        Main.qml
        # Components
        qml/components/Theme.qml
        qml/components/MenuItemC.qml
        qml/components/NavBtn.qml
        qml/components/StatusBar.qml
        # Pages
        qml/pages/MainMenuPage.qml
        qml/pages/LanguageMenuPage.qml
        qml/pages/DurationMenuPage.qml
        qml/pages/CustomDurationPage.qml
        qml/pages/ModeMenuPage.qml
        qml/pages/ManualSetupPage.qml
        qml/pages/CampaignMenuPage.qml
        qml/pages/ResultsPage.qml
        qml/pages/HistoryPage.qml
        qml/pages/CreditsPage.qml
        qml/pages/ResetHistoryPage.qml
        qml/pages/ResetProgressPage.qml
        qml/pages/GameplayPage.qml
    RESOURCES
        assets/font/JetBrainsMono.ttf
        assets/icons/globe.svg
        assets/icons/clock.svg
        assets/icons/gamepad.svg
        assets/icons/volume-on.svg
        assets/icons/volume-off.svg
        assets/icons/play.svg
        assets/icons/history.svg
        assets/icons/close.svg
        assets/icons/arrow-left.svg
        assets/icons/arrow-right.svg
        assets/icons/campaign.svg
        assets/icons/manual.svg
        assets/icons/hand.svg
        assets/icons/trophy.svg
        assets/icons/leaf.svg
        assets/icons/trend-up.svg
        assets/icons/fire.svg
        assets/icons/monitor.svg
        assets/icons/users.svg
        assets/icons/user.svg
        assets/icons/refresh.svg
        assets/icons/trash.svg
        assets/icons/warning.svg
        assets/icons/check.svg
        assets/icons/heart.svg
        assets/icons/target.svg
        assets/icons/lock.svg
        assets/icons/unlock.svg
        assets/icons/terminal.svg
        assets/icons/send.svg
        assets/icons/arrow-down-circle.svg
        assets/icons/cpu.svg
        assets/icons/info.svg
        assets/icons/infinity.svg
        assets/icons/sliders.svg
)

set_target_properties(RapidTexterGUI PROPERTIES
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(RapidTexterGUI
    PRIVATE Qt6::Quick Qt6::QuickControls2
)
