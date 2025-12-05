import Quickshell
import Quickshell.I3
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import qs.Components
import qs.Services

Variants {
  model: Quickshell.screens

  PanelWindow {
    required property ShellScreen modelData
    readonly property int contentHeight: 30
    readonly property int radius: 15
    screen: modelData
    id: "root"

    anchors {
      top: true
      left: true
      right: true
    }
    color: "transparent"
    implicitHeight: contentHeight + radius

    Item {
      id: "content"

      anchors {
        top: parent.top
        left: parent.left
        right: parent.right
      }

      implicitHeight: 0

      // TODO: not invisible when implicitHeight = 0
      // Slide down animation on create (after delay to account for background animation)
      Timer {
        running: true
        interval: 100
        onTriggered: content.implicitHeight = root.contentHeight;
      }

      Behavior on implicitHeight {
        NumberAnimation {
          duration: 100
        }
      }

      Rectangle {
        color: "black"
        anchors.fill: parent
      }

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: root.radius
        anchors.rightMargin: root.radius

        uniformCellSizes: true

        // Workspace Indicator
        Text {
          text: I3.focusedWorkspace.number
          color: "white"
        }

        // Clock
        Text {
          Layout.alignment: Qt.AlignHCenter
          text: Time.time
          color: "white"
        }

        RowLayout {
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
              implicitSize: content.implicitHeight / 2

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

    // Left Corner
    Shape {
      anchors {
        top: content.bottom
        left: parent.left
      }
      implicitHeight: root.radius
      implicitWidth: root.radius
      preferredRendererType: Shape.CurveRenderer

      ShapePath {
        strokeWidth: 0
        fillColor: "black" // TODO: bar.color
        pathHints: ShapePath.PathSolid & ShapePath.PathNonIntersecting

        PathAngleArc {
          moveToStart: false
          centerX: root.radius
          centerY: root.radius
          radiusX: root.radius
          radiusY: root.radius
          startAngle: 180
          sweepAngle: 90
        }
        PathLine {
          x: 0
          y: 0
        }
      }
    }

    // Right Corner
    Shape {
      anchors {
        top: content.bottom
        right: parent.right
      }
      implicitHeight: root.radius
      implicitWidth: root.radius
      preferredRendererType: Shape.CurveRenderer

      ShapePath {
        strokeWidth: 0
        fillColor: "black"
        pathHints: ShapePath.PathSolid & ShapePath.PathNonIntersecting

        PathAngleArc {
          moveToStart: false
          centerX: 0
          centerY: root.radius
          radiusX: root.radius
          radiusY: root.radius
          startAngle: -90
          sweepAngle: 90
        }
        PathLine {
          x: root.radius
          y: 0
        }
      }
    }
  }
}

