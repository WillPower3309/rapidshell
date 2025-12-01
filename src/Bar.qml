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
    color: "transparent"
    implicitHeight: 0

    // Slide down animation on create (after delay to account for background animation)
    Timer {
      running: true
      interval: 100
      onTriggered: bar.implicitHeight = 30;
    }
    Behavior on implicitHeight {
      NumberAnimation {
        duration: 100
      }
    }

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

        MaterialSymbol {
          visible: UPower.displayDevice.ready
          icon: {
            const batteryLevel = UPower.displayDevice.percentage;

            if (batteryLevel >= 0.9) {
              return "battery_android_full"
            }
            if (batteryLevel >= 0.75) {
              return "battery_android_6"
            }
            if (batteryLevel >= 0.6) {
              return "battery_android_5"
            }
            if (batteryLevel >= 0.5) {
              return "battery_android_4"
            }
            if (batteryLevel >= 0.3) {
              return "battery_android_3"
            }
            if (batteryLevel >= 0.2) {
              return "battery_android_2"
            }
            if (batteryLevel >= 0.1) {
              return "battery_android_1"
            }
            return "battery_android_alert"
          }
        }
      }
    }
  }
}

