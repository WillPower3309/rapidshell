import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Components

Scope {
  LazyLoader {
    id: root
    active: false
    loading: true

    PanelWindow {
      id: launcher

      readonly property var options: [
        [ "power_settings_new", [ "systemctl", "poweroff" ] ],
        [ "replay", [ "systemctl", "reboot" ] ],
        [ "moon_stars", [ "systemctl", "suspend" ] ],
      ]

      function execPowerOption(index: int) {
        root.active = false;
        Quickshell.execDetached(launcher.options[index][1]);
      }

      anchors.right: true
      color: "black"
      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

      ListView {
        id: list

        anchors.fill: parent
        spacing: 8

        focus: true
        currentIndex: 0
        keyNavigationWraps: true
        Keys.onEscapePressed: root.active = false;
        Keys.onReturnPressed: execPowerOption(list.currentIndex);

        preferredHighlightBegin: 0
        preferredHighlightEnd: height
        highlightRangeMode: ListView.ApplyRange
        highlightMoveDuration: 80
        highlight: Rectangle {
          radius: width / 2
          color: "gray"
        }

        model: options

        delegate: MaterialSymbol {
          required property var modelData
          required property int index

          icon: modelData[0]
          Layout.alignment: Qt.AlignHCenter

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: list.currentIndex = index;
            onClicked: execPowerOption(index);
          }
        }
      }
    }
  }

  IpcHandler {
    target: "powermenu"
    function toggle(): void { root.active = !root.active; }
  }
}

