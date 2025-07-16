pragma ComponentBehavior: Bound

import QtQuick
import "root:/modules/common"
import "root:/utils"

Row {
    id: root
    spacing: 8

    NerdWidget {
        id: datetime
        icon: ""
        text: Datetime.datetime
        leftColor: Config.colors.pink
        iconColor: Config.colors.base
        rightColor: Config.colors.base
        textColor: datetime.leftColor
        textFont.bold: true
    }
}
