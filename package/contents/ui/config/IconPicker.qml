/*
 * IconPicker taken from Redshift Control applet by Martin Kotelnik:
 * https://github.com/kotelnik/plasma-applet-redshift-control
 *
 * Copyright 2015  Martin Kotelnik <clearmartin@seznam.cz>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kquickcontrolsaddons as KQuickAddons
import org.kde.ksvg as KSvg
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

// basically taken from kickoff
QQC2.Button {
    id: iconButton

    property string currentIcon
    property string defaultIcon

    signal iconChanged(string iconName)

    Layout.minimumWidth: previewFrame.width + Kirigami.Units.smallSpacing * 2
    Layout.maximumWidth: Layout.minimumWidth
    Layout.minimumHeight: previewFrame.height + Kirigami.Units.smallSpacing * 2
    Layout.maximumHeight: Layout.minimumWidth

    KQuickAddons.IconDialog {
        id: iconDialog
        onIconNameChanged: {
            iconPreview.source = iconName
            iconChanged(iconName)
        }
    }

    // just to provide some visual feedback, cannot have checked without checkable enabled
    checkable: true
    onClicked: {
        checked = Qt.binding(function() { // never actually allow it being checked
            return iconMenu.visible
        })

        iconMenu.popup()
    }

    KSvg.FrameSvgItem {
        id: previewFrame
        anchors.centerIn: parent
        imagePath: "widgets/background"
        width: Kirigami.Units.iconSizes.large + fixedMargins.left + fixedMargins.right
        height: Kirigami.Units.iconSizes.large + fixedMargins.top + fixedMargins.bottom

        Kirigami.Icon {
            id: iconPreview
            anchors.centerIn: parent
            width: Kirigami.Units.iconSizes.large
            height: width
            source: currentIcon
        }
    }

    function setDefaultIcon() {
        iconPreview.source = defaultIcon
        iconChanged(defaultIcon)
    }

    // QQC Menu can only be opened at cursor position, not a random one
    QQC2.Menu {
        id: iconMenu

        QQC2.MenuItem {
            text: i18nc("@item:inmenu Open icon chooser dialog", "Choose...")
            icon.name: "document-open-folder"
            onTriggered: iconDialog.open()
        }
        QQC2.MenuItem {
            text: i18nc("@item:inmenu Reset icon to default", "Clear Icon")
            icon.name: "edit-clear"
            onTriggered: setDefaultIcon()
        }
    }
}
