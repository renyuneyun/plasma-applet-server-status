import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
	id: configNotifications

	property string cfg_notificationUp: Plasmoid.configuration.notificationUp
	property string cfg_notificationDown: Plasmoid.configuration.notificationDown

	Component.onCompleted: {
		try {
			var notificationUp = JSON.parse(cfg_notificationUp || '{"action": 0, "extraOptions": {"command": ""}}');

			notifyUpAction.currentIndex = notificationUp.action || 0;
			notifyUpCommand.text = notificationUp.extraOptions ? notificationUp.extraOptions.command : "";


			var notificationDown = JSON.parse(cfg_notificationDown || '{"action": 0, "extraOptions": {"command": ""}}');

			notifyDownAction.currentIndex = notificationDown.action || 0;
			notifyDownCommand.text = notificationDown.extraOptions ? notificationDown.extraOptions.command : "";
		} catch (e) {
			console.log("Error parsing notification configuration:", e);
		}
	}

	ColumnLayout {
		anchors.fill: parent

		QQC2.GroupBox {
			id: notificationUpGroup
			title: "When server goes online"
			Layout.fillWidth: true

			Kirigami.FormLayout {
				QQC2.Label {
					text: i18n("Action:")
				}

				QQC2.ComboBox {
					id: notifyUpAction
					model: ["Nothing", "System notification", "Command"]
					Layout.minimumWidth: Kirigami.Units.gridUnit * 20
					onCurrentIndexChanged: {
						updateData();

						notifyUpCommand.visible = (currentIndex == 2)
					}
				}

				QQC2.TextField {
					id: notifyUpCommand
					Layout.fillWidth: true
					visible: false
					placeholderText: i18n("Command:")
					onTextChanged: updateData()
				}
			}
		}

		QQC2.GroupBox {
			id: notificationDownGroup
			title: "When server goes offline"
			Layout.fillWidth: true

			Kirigami.FormLayout {
				QQC2.Label {
					text: i18n("Action:")
				}

				QQC2.ComboBox {
					id: notifyDownAction
					model: ["Nothing", "System notification", "Command"]
					Layout.minimumWidth: Kirigami.Units.gridUnit * 20
					onCurrentIndexChanged: {
						updateData();

						notifyDownCommand.visible = (currentIndex == 2)
					}
				}

				QQC2.TextField {
					id: notifyDownCommand
					Layout.fillWidth: true
					visible: false
					placeholderText: i18n("Command:")
					onTextChanged: updateData()
				}
			}
		}
	}

	function updateData() {
		var notificationUp = {
			action: notifyUpAction.currentIndex,
			extraOptions: {
				command: notifyUpCommand.text
			}
		};

		cfg_notificationUp = JSON.stringify(notificationUp);


		var notificationDown = {
			action: notifyDownAction.currentIndex,
			extraOptions: {
				command: notifyDownCommand.text
			}
		};

		cfg_notificationDown = JSON.stringify(notificationDown);
	}
}
