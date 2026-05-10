import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: notesList

    property alias internalList: listView

    // 1. Header with Dynamic Count
    header: ToolBar {
        background: Rectangle { color: "#f3f3f3" }
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 15
            Label {
                text: "Notes List (Count: " + listView.count + ")"
                font.pixelSize: 24
                font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // Main Column to stack List and Buttons
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 2. The List
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: notesModel
            highlightFollowsCurrentItem: true

            // Disables scrolling/flicking when an item is being dragged
            interactive: !draggingOngoing

            property bool draggingOngoing: false

            delegate: ItemDelegate {
                id: delegateRoot
                width: listView.width
                height: 60

                property bool isHeld: dragArea.held

                // The text content is automatically placed above the background
                contentItem: RowLayout {
                    spacing: 10
                    z: 2 // Explicitly ensure text is above the background
                    Text {
                        text: "•"
                        font.bold: true
                        color: delegateRoot.isHeld ? "#0078d4" : "black"
                    }
                    ColumnLayout {
                        spacing: 2
                        Label {
                            text: model.title
                            font.bold: true
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        Label {
                            text: "[" + model.date + "]"
                            font.pixelSize: 10
                            color: "gray"
                        }
                    }
                }

                // Drag and Drop Logic
                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    property bool held: false

                    onPressAndHold: {
                        held = true
                        listView.draggingOngoing = true
                        listView.currentIndex = index
                    }
                    onReleased: {
                        held = false
                        listView.draggingOngoing = false
                    }
                    onCanceled: {
                        held = false
                        listView.draggingOngoing = false
                    }

                    onClicked: listView.currentIndex = index

                    onPositionChanged: (mouse) => {
                        if (held) {
                            var targetIndex = listView.indexAt(delegateRoot.x, delegateRoot.y + mouse.y + listView.contentY)
                            if (targetIndex !== -1 && targetIndex !== index) {
                                notesModel.moveNote(index, targetIndex)
                            }
                        }
                    }
                }

                // The background layer stays at the bottom
                background: Rectangle {
                    color: delegateRoot.isHeld ? "#d0e4ff" :
                           (listView.currentIndex === index ? "#e8f2ff" : "white")

                    border.color: "#dddddd"
                    border.width: 0.5

                    // Blue selection/active indicator
                    Rectangle {
                        anchors.left: parent.left
                        height: parent.height
                        width: 4
                        color: "#0078d4"
                        visible: listView.currentIndex === index || delegateRoot.isHeld
                    }
                }
            }
        }

        // 3. Footer with Action Buttons
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: "#f3f3f3"
            border.color: "#cccccc"

            RowLayout {
                anchors.centerIn: parent
                spacing: 20

                Button {
                    text: "Add Note"
                    onClicked: notesModel.addNote("New Note")
                }

                Button {
                    text: "Delete"
                    enabled: listView.currentIndex >= 0
                    onClicked: notesModel.removeNote(listView.currentIndex)
                }
            }
        }
    }
}