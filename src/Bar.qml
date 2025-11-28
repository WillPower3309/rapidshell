import Quickshell
import Quickshell.I3
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.Components
import qs.Services

Variants {
  model: Quickshell.screens

  PanelWindow {
    required property ShellScreen modelData
    screen: modelData
    id: "bar"

    anchors {
      top: true
      left: true
      right: true
    }
    implicitHeight: 30

    color: "black"

    RowLayout {
      anchors.fill: parent
      uniformCellSizes: true

      // Workspace Indicator
      Text {
        text: I3.focusedWorkspace.number
        color: "white"
        Layout.leftMargin: 15
      }

      // Clock
      Text {
        text: Time.time
        color: "white"
        Layout.alignment: Qt.AlignHCenter
      }

      RowLayout {
        Layout.rightMargin: 15
        Layout.alignment: Qt.AlignRight
        spacing: 10

        MaterialSymbol {
          icon: Volume.sourceIcon
        }

        MaterialSymbol {
          icon: Volume.sinkIcon
        }

        // System Tray
        Repeater {
          model: SystemTray.items
          delegate: IconImage {
            required property SystemTrayItem modelData

            id: root
            source: modelData.icon
            implicitSize: bar.implicitHeight / 2

            MouseArea {
              anchors.fill: parent

              acceptedButtons: Qt.LeftButton | Qt.RightButton
              onClicked: (mouse) => {
                if (mouse.button == Qt.LeftButton) {
                  modelData.activate();
                } else if (modelData.hasMenu) {
                  menu.open();
                }
              }

              // TODO: proper position
              QsMenuAnchor {
                id: menu
                menu: root.modelData.menu
                anchor.window: this.QsWindow.window
              }
            }
          }
        }

        // Battery Indicator
        // TODO: material symbol
        Text {
          visible: UPower.displayDevice.ready
          text: `${Math.round(100 * UPower.displayDevice.percentage)}%`
          color: "white"
        }
      }
    }
  }
}

