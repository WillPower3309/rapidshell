import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick

Variants {
  model: Quickshell.screens

  PanelWindow {
    required property ShellScreen modelData
    screen: modelData
    color: "black"
    exclusionMode: ExclusionMode.Ignore

    anchors {
      top: true
      left: true
      right: true
      bottom: true
    }

    WlrLayershell.layer: WlrLayer.Background

    ClippingWrapperRectangle {
      anchors.fill: parent
      anchors.margins: 50
      radius: 15

      // TODO: proper animation for pop in
      NumberAnimation on anchors.margins {
        to: 0
        duration: 100
      }

      Image {
        source: "assets/wallpaper.png"
      }
    }
  }
}

