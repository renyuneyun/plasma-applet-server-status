import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

import ".."

KCM.SimpleKCM {
	id: configGeneral

	property string cfg_servers: Plasmoid.configuration.servers

	property int dialogMode: -1

	ServersModel {
		id: serversModel
	}

	Component.onCompleted: {
		serversModel.clear();

		try {
			var servers = JSON.parse(cfg_servers || '[]');

			for(var i = 0; i < servers.length; i++) {
				serversModel.append(servers[i]);
			}
		} catch (e) {
			console.log("Error parsing servers configuration:", e);
		}
	}

	RowLayout {
		anchors.fill: parent

		QQC2.ScrollView {
			id: serversScrollView
			Layout.fillWidth: true
			Layout.fillHeight: true
			Layout.rightMargin: Kirigami.Units.smallSpacing

			ListView {
				id: serversList
				model: serversModel

				delegate: QQC2.ItemDelegate {
					width: ListView.view.width
					height: Kirigami.Units.gridUnit * 2

					RowLayout {
						anchors.fill: parent
						anchors.margins: Kirigami.Units.smallSpacing

						QQC2.CheckBox {
							checked: model.active
							onToggled: {
								model.active = checked;
								cfg_servers = JSON.stringify(getServersArray());
							}
						}

						QQC2.Label {
							Layout.fillWidth: true
							text: model.name || model.hostname
							elide: Text.ElideRight
						}
					}

					onDoubleClicked: {
						editServer(index);
					}
				}
			}
		}

		ColumnLayout {
			id: buttonsColumn

			QQC2.Button {
				text: "Add..."
				icon.name: "list-add"

				onClicked: {
					addServer();
				}
			}

			QQC2.Button {
				text: "Edit"
				icon.name: "edit-entry"
				enabled: serversList.currentIndex >= 0

				onClicked: {
					editServer(serversList.currentIndex);
				}
			}

			QQC2.Button {
				text: "Remove"
				icon.name: "list-remove"
				enabled: serversList.currentIndex >= 0

				onClicked: {
					if(serversList.currentIndex == -1) return;

					serversModel.remove(serversList.currentIndex);

					cfg_servers = JSON.stringify(getServersArray());
				}
			}

			QQC2.Button {
				id: moveUp
				text: i18n("Move up")
				icon.name: "go-up"
				enabled: serversList.currentIndex > 0

				onClicked: {
					if(serversList.currentIndex == -1) return;

					serversModel.move(serversList.currentIndex, serversList.currentIndex - 1, 1);
					serversList.currentIndex = serversList.currentIndex - 1;
				}
			}

			QQC2.Button {
				id: moveDown
				text: i18n("Move down")
				icon.name: "go-down"
				enabled: serversList.currentIndex >= 0 && serversList.currentIndex < serversModel.count - 1

				onClicked: {
					if(serversList.currentIndex == -1) return;

					serversModel.move(serversList.currentIndex, serversList.currentIndex + 1, 1);
					serversList.currentIndex = serversList.currentIndex + 1;
				}
			}
		}
	}


	QQC2.Dialog {
		id: serverDialog
		title: "Server"
		modal: true
		standardButtons: QQC2.Dialog.Save | QQC2.Dialog.Cancel

		onAccepted: {
			var itemObject = {
				name: serverName.text,
				hostname: serverHostname.text,
				refreshRate: serverRefreshRate.value,
				method: serverMethod.currentIndex,
				active: serverActive.checked,
				extraOptions: {
					command: serverCommand.text
				}
			};

			if(dialogMode == -1) {
				serversModel.append(itemObject);
			} else {
				serversModel.set(dialogMode, itemObject);
			}

			cfg_servers = JSON.stringify(getServersArray());
		}

		ColumnLayout {
			Kirigami.FormLayout {
				QQC2.Label {
					text: "Name:"
				}

				QQC2.TextField {
					id: serverName
					Layout.minimumWidth: Kirigami.Units.gridUnit * 20
				}

				QQC2.Label {
					text: "Host name:"
				}

				QQC2.TextField {
					id: serverHostname
					Layout.minimumWidth: Kirigami.Units.gridUnit * 20
				}

				QQC2.Label {
					text: i18n("Refresh rate:")
				}

				QQC2.SpinBox {
					id: serverRefreshRate
					textFromValue: function(value) {
						return value + i18n(" seconds")
					}
					valueFromText: function(text) {
						return parseInt(text)
					}
					from: 1
					to: 3600
				}

				QQC2.Label {
					text: i18n("Check method:")
				}

				QQC2.ComboBox {
					id: serverMethod
					model: ["Ping", "PingV6", "HTTP 200 OK", "Command"]
					Layout.minimumWidth: Kirigami.Units.gridUnit * 15
					onActivated: {
						commandGroup.visible = (index == 3)
					}
				}

				QQC2.CheckBox {
					id: serverActive
					text: i18n("Active")
				}
			}

			QQC2.GroupBox {
				id: commandGroup
				title: "Command"
				visible: false
				Layout.fillWidth: true

				ColumnLayout {
					anchors.fill: parent

					QQC2.TextField {
						id: serverCommand
						Layout.fillWidth: true
					}

					QQC2.Label {
						Layout.fillWidth: true
						wrapMode: Text.WordWrap
						text: i18n("Use %hostname% to pass server's hostname as an argument or option to the executable.")
					}
				}
			}
		}
	}

	function addServer() {
		dialogMode = -1;

		serverName.text = ""
		serverHostname.text = ""
		serverRefreshRate.value = 60
		serverMethod.currentIndex = 0
		serverActive.checked = true

		serverDialog.open();
		serverName.forceActiveFocus();
	}

	function editServer(index) {
		dialogMode = index;

		var server = serversModel.get(dialogMode);
		serverName.text = server.name || ""
		serverHostname.text = server.hostname || ""
		serverRefreshRate.value = server.refreshRate || 60
		serverMethod.currentIndex = server.method || 0
		serverActive.checked = server.active || true
		serverCommand.text = server.extraOptions ? server.extraOptions.command || "" : ""

		serverDialog.open();
		serverName.forceActiveFocus();
	}

	function getServersArray() {
		var serversArray = [];

		for(var i = 0; i < serversModel.count; i++) {
			serversArray.push(serversModel.get(i));
		}

		return serversArray;
	}
}
