import QtQuick
import QtQuick.Layouts

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
            Layout.preferredWidth: 300
            Layout.fillHeight: true
        }

        NotesEditor{
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
