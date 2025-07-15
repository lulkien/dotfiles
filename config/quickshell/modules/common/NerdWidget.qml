pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property string icon: ""
    property string text: "Sample Text"
    property real padding: 12
    property real widgetHeight: 32
    property real borderRadius: 8
    property color leftColor: "steelblue"
    property color rightColor: "lightgray"
    property color textColor: "black"
    property bool clip: false

    implicitWidth: layout.implicitWidth
    implicitHeight: widgetHeight

    RowLayout {
        id: layout
        spacing: 0

        FlexRectangle {
            id: left
            Layout.preferredWidth: root.widgetHeight
            Layout.preferredHeight: root.widgetHeight
            color: root.leftColor

            topLeftRadius: root.borderRadius
            topRightRadius: 0
            bottomLeftRadius: root.borderRadius
            bottomRightRadius: 0

            clip: root.clip

            NerdText {
                id: iconText
                color: root.textColor
                anchors.centerIn: parent
                padding: root.padding
                text: root.icon

                font.pixelSize: Math.max(12, parent.height * 0.5)
            }
        }

        FlexRectangle {
            id: right
            Layout.preferredHeight: root.widgetHeight
            Layout.preferredWidth: contentText.width
            // Layout.fillWidth: false
            color: root.rightColor

            topLeftRadius: 0
            topRightRadius: root.borderRadius
            bottomLeftRadius: 0
            bottomRightRadius: root.borderRadius

            NerdText {
                id: contentText
                text: root.text
                color: root.textColor
                anchors.centerIn: parent
                padding: root.padding

                font.pixelSize: Math.max(12, parent.height * 0.5)
            }

            clip: root.clip
        }
    }
}
