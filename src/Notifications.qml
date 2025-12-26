import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

Scope {
  NotificationServer {
    property list<Notification> notifications: []

    id: server
    bodySupported: true

    onNotification: notification => {
      notification.tracked = true
      notifications = [ notification, ...notifications ]
    }
  }

  PanelWindow {
    visible: server.notifications.length > 0
    color: "black"

    anchors.top: true
    anchors.right: true

    ColumnLayout {
      Repeater {
        model: server.notifications

        delegate: Item {
          required property Notification modelData

          Rectangle {
            color: "black"
          }

          ColumnLayout {
            Text {
              color: "white"
              text: modelData.summary
            }
            Text {
              color: "white"
              text: modelData.body
            }
          }
        }
      }
    }
  }
}

