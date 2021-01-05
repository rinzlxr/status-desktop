import QtQuick 2.3
import "../../../../../shared"
import "../../../../../shared/status"
import "../../../../../imports"
import "./TransactionComponents"
import "../../../Wallet/data"

Item {
    property var invitedCommunity
    property int innerMargin: 12
    property bool joined: false

    id: root
    anchors.left: parent.left
    height: childrenRect.height

    Component.onCompleted: {
        chatsModel.setObservedCommunity(communityId)

        root.invitedCommunity = chatsModel.observedCommunity
    }

    UserImage {
        id: chatImage
        visible: authorCurrentMsg != authorPrevMsg && !isCurrentUser
        anchors.left: parent.left
        anchors.leftMargin: Style.current.padding
        anchors.top: parent.top
    }

    Loader {
        id: rectangleBubbleLoader
        active: !!invitedCommunity
        width: item.width
        height: item.height
        anchors.right: isCurrentUser ? parent.right : undefined
        anchors.rightMargin: Style.current.padding
        anchors.left: !isCurrentUser ? chatImage.right : undefined
        anchors.leftMargin: Style.current.smallPadding

        sourceComponent: Component {
            Rectangle {
                id: rectangleBubble
                width: 270
                height: childrenRect.height + Style.current.halfPadding
                radius: 16
                color: Style.current.background
                border.color: Style.current.border
                border.width: 1

                // TODO add check if verified
                StyledText {
                    id: title
                    color: invitedCommunity.verifed ? Style.current.primary : Style.current.secondaryText
                    text: invitedCommunity.verifed ?
                              qsTr("Verified community invitation") :
                              qsTr("Community invitation")
                    font.weight: Font.Medium
                    anchors.top: parent.top
                    anchors.topMargin: Style.current.halfPadding
                    anchors.left: parent.left
                    anchors.leftMargin: root.innerMargin
                    font.pixelSize: 13
                }

                StyledText {
                    id: invitedYou
                    text: qsTr("%1 invited you to join a community").arg(userName)
                    anchors.top: title.bottom
                    anchors.topMargin: 4
                    anchors.left: parent.left
                    anchors.leftMargin: root.innerMargin
                    anchors.right: parent.right
                    anchors.rightMargin: root.innerMargin
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                }

                Separator {
                    id: sep1
                    anchors.top: invitedYou.bottom
                    anchors.topMargin: Style.current.halfPadding
                }

                // TODO add image when it's supported
                StyledText {
                    id: communityName
                    text: invitedCommunity.name
                    anchors.top: sep1.bottom
                    anchors.topMargin: root.innerMargin
                    anchors.left: parent.left
                    anchors.leftMargin: root.innerMargin
                    anchors.right: parent.right
                    anchors.rightMargin: root.innerMargin
                    font.weight: Font.Bold
                    wrapMode: Text.WordWrap
                    font.pixelSize: 17
                }

                StyledText {
                    id: communityDesc
                    text: invitedCommunity.description
                    anchors.top: communityName.bottom
                    anchors.topMargin: 2
                    anchors.left: parent.left
                    anchors.leftMargin: root.innerMargin
                    anchors.right: parent.right
                    anchors.rightMargin: root.innerMargin
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                }

                StyledText {
                    id: communityNbMembers
                    // TODO add the plural support
                    text: qsTr("%1 members").arg(invitedCommunity.nbMembers)
                    anchors.top: communityDesc.bottom
                    anchors.topMargin: 2
                    anchors.left: parent.left
                    anchors.leftMargin: root.innerMargin
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    color: Style.current.secondaryText
                }

                Separator {
                    id: sep2
                    anchors.top: communityNbMembers.bottom
                    anchors.topMargin: Style.current.halfPadding
                }

                StatusButton {
                    type: "secondary"
                    anchors.top: sep2.bottom
                    width: parent.width
                    height: 44
                    enabled: !invitedCommunity.joined
                    text: root.joined || invitedCommunity.joined ? qsTr("Joined") :
                        qsTr("Join")
                    onClicked: {
                        chatsModel.joinCommunity(communityId)
                        root.joined = true
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#4c4e50";formeditorZoom:1.25}
}
##^##*/