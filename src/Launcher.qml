import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.LocalStorage
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

// TODO: animation

Scope {
  PanelWindow {
    id: root
    color: "transparent"
    visible: false
    anchors.bottom: true
    implicitHeight: 700 // TODO: half screen height
    implicitWidth: 700 // TODO: third screen width
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    property string query: ""

    function launchSelected() {
      if (list.currentItem && list.currentItem.modelData) {
        list.currentItem.modelData.execute();
        root.visible = false;
      }
    }

    Item {
      implicitHeight: 700
      implicitWidth: 700

      // Background
      Rectangle {
        anchors.fill: parent
        color: "black"
        topLeftRadius: 25
        topRightRadius: 25
      }

      ColumnLayout {
        anchors.margins: 15
        anchors.fill: parent
        spacing: 8

        ListView {
          id: list
          Layout.fillWidth: true
          Layout.fillHeight: true
          clip: true
          model: filtered.values
          currentIndex: filtered.values.length > 0 ? 0 : -1
          keyNavigationWraps: true

          preferredHighlightBegin: 0
          preferredHighlightEnd: height
          highlightRangeMode: ListView.ApplyRange
          highlightMoveDuration: 80
          highlight: Rectangle {
            radius: 10
            opacity: 0.45
            color: input.palette.highlight
          }

          delegate: Item {
            id: entry
            required property var modelData
            required property int index
            width: ListView.view.width
            height: 36

            MouseArea {
              anchors.fill: parent
              hoverEnabled: true
              onEntered: list.currentIndex = entry.index
              onClicked: root.launchSelected()
            }

            Row {
              anchors.fill: parent
              anchors.margins: 8
              spacing: 10

              IconImage {
                source: Quickshell.iconPath(modelData.icon, true)
                width: 23
                height: 23
              }
              Text {
                id: label
                color: "white"
                text: modelData.name
                font.pointSize: 13
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
              }
            }
          }

          // Enter also works while ListView has focus
          Keys.onReturnPressed: root.launchSelected()
        }

        RowLayout {
          IconImage {
            Layout.leftMargin: 10
            source: Quickshell.iconPath("nix-snowflake", true)
            Layout.preferredWidth: 25
            Layout.preferredHeight: 25
          }

          TextField {
            id: input
            Layout.fillWidth: true
            placeholderText: "Run…"
            placeholderTextColor: "gray"
            font.pixelSize: 18
            color: "white"
            focus: true

            padding: 15

            onTextChanged: {
              root.query = text;
              // reset selection to first item of the filtered list
              list.currentIndex = filtered.values.length > 0 ? 0 : -1;
            }

            background: Rectangle {
              border.width: 0
              color: "transparent"
            }

            // Quit
            Keys.onEscapePressed: root.visible = false;
            Keys.onPressed: event => {
              const ctrl = event.modifiers & Qt.ControlModifier;
              if (event.key == Qt.Key_Up || event.key == Qt.Key_P && ctrl) {
                event.accepted = true;
                if (list.currentIndex > 0)
                  list.currentIndex--;
              } else if (event.key == Qt.Key_Down || event.key == Qt.Key_N && ctrl) {
                event.accepted = true;
                if (list.currentIndex < list.count - 1)
                  list.currentIndex++;
              } else if ([Qt.Key_Return, Qt.Key_Enter].includes(event.key)) {
                event.accepted = true;
                root.launchSelected();
              } else if (event.key == Qt.Key_C && ctrl) {
                event.accepted = true;
                root.visible = false;
              }
            }
          }
        }

        // Filtered model: only items matching the query
        ScriptModel {
          id: filtered
          values: {
            const allEntries = [...DesktopEntries.applications.values];
            const q = root.query.trim();

            if (q === "") {
              return allEntries;
            } else {
              return allEntries.filter(d => d.name && d.name.toLowerCase().includes(q));
            }
          }
        }
      }
    }
  }

  IpcHandler {
    target: "launcher"
    function toggle(): void { root.visible = !root.visible; }
  }
}

