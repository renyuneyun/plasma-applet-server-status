import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
	id: configAppearance

	property alias cfg_fontSize: fontSize.value
	property string cfg_iconOnline: Plasmoid.configuration.iconOnline
	property string cfg_iconOffline: Plasmoid.configuration.iconOffline

	Kirigami.FormLayout {
		QQC2.SpinBox {
			id: fontSize
			Kirigami.FormData.label: i18n("Font size:")
			textFromValue: function(value) {
				return value + i18n(" pt")
			}
			valueFromText: function(text) {
				return parseInt(text)
			}
			from: 1
			to: 128
		}

		IconPicker {
			Kirigami.FormData.label: i18n("Online icon:")
			currentIcon: cfg_iconOnline
			defaultIcon: "security-high"
			onIconChanged: cfg_iconOnline = iconName
			enabled: true
		}

		IconPicker {
			Kirigami.FormData.label: i18n("Offline icon:")
			currentIcon: cfg_iconOffline
			defaultIcon: "security-low"
			onIconChanged: cfg_iconOffline = iconName
			enabled: true
		}
	}
}
