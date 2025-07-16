pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property string icon: ""
    property string text: "Sample Text"
    property real padding: 8
    property real widgetHeight: 34
    property real borderRadius: 8
    property alias leftColor: left.color
    property alias rightColor: right.color
    property alias iconColor: iconText.color
    property alias textColor: contentText.color
    property alias textFont: contentText.font
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
            color: "steelblue"

            topLeftRadius: root.borderRadius
            topRightRadius: 0
            bottomLeftRadius: root.borderRadius
            bottomRightRadius: 0

            clip: root.clip

            NerdText {
                id: iconText
                color: "black"
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
            color: "lightgray"

            topLeftRadius: 0
            topRightRadius: root.borderRadius
            bottomLeftRadius: 0
            bottomRightRadius: root.borderRadius

            NerdText {
                id: contentText
                text: root.text
                color: "black"
                anchors.centerIn: parent
                padding: root.padding

                font.pixelSize: Math.max(12, parent.height * 0.5)
            }

            clip: root.clip
        }
    }
}
