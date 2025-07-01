import QtQuick

import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
         name: i18n("General")
         icon: "preferences-system-windows"
         source: "config/configGeneral.qml"
    }
    ConfigCategory {
         name: i18n("Appearance")
         icon: "preferences-desktop-color"
         source: "config/configAppearance.qml"
    }
    ConfigCategory {
         name: i18n("Notifications")
         icon: "preferences-desktop-notification"
         source: "config/configNotifications.qml"
    }
}
