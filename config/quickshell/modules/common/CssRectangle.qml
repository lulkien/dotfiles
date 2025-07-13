import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    property real topLeftRadius: 16
    property real topRightRadius: 0
    property real bottomLeftRadius: 16
    property real bottomRightRadius: 0

    width: 150
    implicitHeight: 40

    layer.enabled: true
    layer.samples: 8

    QtObject {
        id: self
        readonly property real maxBorderRadius: Math.min(root.width, root.height) / 2

        property real topLeftRadius: Math.min(maxBorderRadius, root.topLeftRadius)
        property real topRightRadius: Math.min(maxBorderRadius, root.topRightRadius)
        property real bottomLeftRadius: Math.min(maxBorderRadius, root.bottomLeftRadius)
        property real bottomRightRadius: Math.min(maxBorderRadius, root.bottomRightRadius)
    }

    ShapePath {
        fillColor: "steelblue"
        strokeWidth: 0

        startX: self.topLeftRadius
        startY: 0

        PathLine {
            x: root.width - self.topRightRadius
            y: 0
        }
        PathArc {
            x: root.width
            y: self.topRightRadius
            radiusX: self.topRightRadius
            radiusY: self.topRightRadius
        }
        PathLine {
            x: root.width
            y: root.height - self.bottomRightRadius
        }
        PathArc {
            x: root.width - self.bottomRightRadius
            y: root.height
            radiusX: self.bottomRightRadius
            radiusY: self.bottomRightRadius
        }
        PathLine {
            x: self.bottomLeftRadius
            y: root.height
        }
        PathArc {
            x: 0
            y: root.height - self.bottomLeftRadius
            radiusX: self.bottomLeftRadius
            radiusY: self.bottomLeftRadius
        }
        PathLine {
            x: 0
            y: self.topLeftRadius
        }
        PathArc {
            x: self.topLeftRadius
            y: 0
            radiusX: self.topLeftRadius
            radiusY: self.topLeftRadius
        }
    }
}
