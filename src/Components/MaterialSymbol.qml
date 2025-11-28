import QtQuick

// should I download the svgs to the assets folder instead?
Text {
  property string icon

  text: icon
  color: "white"
  renderType: Text.NativeRendering
  textFormat: Text.PlainText
  font.family: "Material Symbols Rounded"
  // TODO: set font.variableAxes
}

