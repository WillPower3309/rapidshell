import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
  LazyLoader {
    id: root
    active: false

    PanelWindow {
      id: launcher
      anchors {
        top: true
        bottom: true
        right: true
      }
      color: "black"

      //WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

      ColumnLayout {
        anchors.fill: parent
        spacing: 8

        Repeater {
          model: [
            [ "system-shutdown-symbolic", [ "systemctl", "poweroff" ] ],
            [ "system-reboot-symbolic", [ "systemctl", "reboot" ] ],
            [ "weather-clear-night-symbolic", [ "systemctl", "suspend" ] ],
          ]
          delegate: Button {
            required property var modelData

            Layout.alignment: Qt.AlignHCenter
            icon.name: modelData[0]
            icon.color: "white"
            onClicked: Quickshell.execDetached(modelData[1]);

            background: Rectangle {
              implicitWidth: 40
              implicitHeight: 40
              color: "gray"
            }
          }
        }

        Keys.onEscapePressed: root.active = false;
      }
    }
  }

  IpcHandler {
    target: "powermenu"
    function toggle(): void { root.active = !root.active; }
  }
}

