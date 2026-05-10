import QtQuick
import QtQuick.Layouts
import Notes

Window {
    id: root
    width: 640
    height: 480
    minimumHeight: 480
    minimumWidth: 640

    visible: true
    title: qsTr("Notes")

    RowLayout{
        id: mainLayout

        anchors.fill: parent
        spacing: 6
        NotesList{
            id: notesListMain

            Layout.preferredWidth: 300
            Layout.fillHeight: true
        }

        NotesEditor{
            targetView: notesListMain.internalList

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
