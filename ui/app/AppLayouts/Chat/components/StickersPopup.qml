import QtQuick 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "../../../../imports"
import "../../../../shared"
import "../ChatColumn/samples"

Popup {
    id: popup
    property var stickerList: StickerData {}
    property var stickerPackList: StickerPackData {}
    modal: false
    property int selectedPackId
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    background: Rectangle {
        radius: 8
        border.color: Theme.grey
        layer.enabled: true
        layer.effect: DropShadow{
            verticalOffset: 3
            radius: 8
            samples: 15
            fast: true
            cached: true
            color: "#22000000"
        }
    }
    contentItem: ColumnLayout {
        parent: popup
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.leftMargin: 4
            Layout.rightMargin: 4
            Layout.topMargin: 4
            Layout.bottomMargin: 0
            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
            Layout.preferredHeight: 400 - 4

            Item {
                id: stickerHistory
                anchors.fill: parent
                visible: true

                Image {
                    id: imgNoStickers
                    width: 56
                    height: 56
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 134
                    source: "../../../img/stickers_sad_icon.svg"
                }

                Text {
                    id: lblNoStickers
                    width: parent.width
                    font.pixelSize: 15
                    text: qsTr("You don't have any stickers yet")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.top: imgNoStickers.bottom
                    anchors.topMargin: 8
                }

                StyledButton {
                    label: qsTr("Get Stickers")
                    anchors.top: lblNoStickers.bottom
                    anchors.topMargin: Theme.padding
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            GridView {
                id: stickerGrid
                visible: false
                anchors.fill: parent
                cellWidth: 88
                cellHeight: 88
                model: stickerList
                focus: true
                clip: true
                delegate: Item {
                    width: stickerGrid.cellWidth
                    height: stickerGrid.cellHeight
                    Column {
                        anchors.fill: parent
                        anchors.topMargin: 4
                        anchors.leftMargin: 4
                        Image {
                            width: 80
                            height: 80
                            fillMode: Image.PreserveAspectFit
                            source: "https://ipfs.infura.io/ipfs/" + url
                            MouseArea {
                                cursorShape: Qt.PointingHandCursor
                                anchors.fill: parent
                                onClicked: {
                                    chatsModel.sendSticker(hash, popup.selectedPackId)
                                    popup.close()
                                }
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: footerContent
            Layout.leftMargin: 8
            Layout.fillWidth: true
            Layout.preferredHeight: 40 - 8 * 2
            Layout.topMargin: 8
            Layout.rightMargin: 8
            Layout.bottomMargin: 8
            Layout.alignment: Qt.AlignTop | Qt.AlignLeft

            AddButton {
                id: btnAddStickerPack
                anchors.left: parent.left
                anchors.top: parent.top
                width: 24
                height: 24
            }

            RoundedIcon {
                id: btnHistory
                size: 24
                color: Theme.darkGrey
                imgPath: "../../../img/history_icon.svg"
                anchors.left: btnAddStickerPack.right
                anchors.leftMargin: Theme.padding
                onClicked: {
                    packIndicator.updatePosition(-1)
                    stickerGrid.visible = false;
                    stickerHistory.visible = true;
                }
            }

            RowLayout {
                spacing: Theme.padding
                anchors.top: parent.top
                anchors.left: btnHistory.right
                anchors.leftMargin: Theme.padding

                Repeater {
                    id: stickerPackListView
                    model: stickerPackList

                    delegate: RoundedImage {
                        Layout.preferredHeight: height
                        Layout.preferredWidth: width
                        width: 24
                        height: 24
                        source: "https://ipfs.infura.io/ipfs/" + thumbnail
                        onClicked: {
                            chatsModel.setActiveStickerPackById(id)
                            popup.selectedPackId = id
                            packIndicator.updatePosition(index)
                            stickerGrid.visible = true;
                            stickerHistory.visible = false;
                        }
                    }
                }
            }
            Rectangle {
                id: packIndicator
                border.color: Theme.blue
                border.width: 1
                height: 2
                width: 16
                x: 44
                y: footerContent.height + 8 - height

                function updatePosition(index) {
                    const startX = 44
                    const skipX = 40
                    const idx = index + 1
                    packIndicator.x = startX + skipX * idx;
                }
            }
        }
    }
}
/*##^##
Designer {
    D{i:0;formeditorColor:"#ffffff";height:440;width:360}
}
##^##*/
