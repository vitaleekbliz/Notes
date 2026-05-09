import QtQuick
import QtQuick.Controls

Page {
    id: notesEditor

    header: Label{
        text: "Notes Editor"
        font.pixelSize: 24
        font.italic: true
        horizontalAlignment: Text.AlignHCenter
    }

    Rectangle {
        anchors.fill: parent
        color: "#f9f9f9"

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10

            TextField {
                id: editorNoteTitle

                placeholderText: "Note Title"
                width: parent.width
                font.pixelSize: 12
            }

            TextArea {
                id: editorNoteContence

                placeholderText: "Start typing..."
                width: parent.width
                height: parent.height - 100
                wrapMode: TextEdit.Wrap
            }
        }
    }
}