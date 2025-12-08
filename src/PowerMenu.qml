import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Components

Scope {
  PanelWindow {
    id: root
    visible: content.width != 0

    color: "transparent"
    anchors.right: true
    implicitHeight: 200
    implicitWidth: 50
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    Item {
      id: content

      anchors.right: parent.right

      implicitHeight: root.implicitHeight
      implicitWidth: 0

      Behavior on implicitWidth {
        NumberAnimation {
          duration: 100
        }
      }

      // Background
      Rectangle {
        anchors.fill: parent
        color: "black"
        topLeftRadius: 25
        bottomLeftRadius: 25
      }

      ListView {
        id: list

        readonly property var options: [
          [ "power_settings_new", [ "systemctl", "poweroff" ] ],
          [ "replay", [ "systemctl", "reboot" ] ],
          [ "moon_stars", [ "systemctl", "suspend" ] ],
        ]

        function execPowerOption(index: int) {
          content.implicitWidth = 0;
          Quickshell.execDetached(options[index][1]);
        }

        anchors.fill: parent
        anchors.margins: 15
        spacing: 8

        focus: true
        currentIndex: 0
        keyNavigationWraps: true
        Keys.onEscapePressed: content.implicitWidth = 0;
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
            onClicked: list.execPowerOption(index);
          }
        }
      }
    }
  }

  IpcHandler {
    target: "powermenu"
    function toggle(): void { content.implicitWidth = content.implicitWidth ? 0 : root.implicitWidth; }
  }
}

