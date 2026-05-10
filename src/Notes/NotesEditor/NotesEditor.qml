import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: notesEditor

    property var targetView: null

    property bool hasSelection: targetView !== null && targetView.currentIndex >= 0

    function loadNote() {
        if (hasSelection) {
            // Using the roles defined in C++ (Qt::UserRole + 1 = 257)
            var idx = targetView.currentIndex;
            var modelIdx = notesModel.index(idx, 0);

            editorNoteTitle.text = notesModel.data(modelIdx, 257) || ""
            editorNoteContence.text = notesModel.data(modelIdx, 258) || ""
        }
    }

    Connections {
        target: targetView
        function onCurrentIndexChanged() {
            loadNote()
        }
    }

    header: Label {
        text: hasSelection ? "Editing: " + editorNoteTitle.text : "No Note Selected"
        font.pixelSize: 24
        font.bold: true
        padding: 10
        horizontalAlignment: Text.AlignHCenter
        color: "black"
    }

    // Main Content
    background: Rectangle {
        id: editorBackground
        color: "#f9f9f9"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10
        enabled: hasSelection

        TextField {
            id: editorNoteTitle
            placeholderText: "Note Title"
            Layout.fillWidth: true
            font.pixelSize: 18
            // Auto-save as user types
            onTextEdited: notesModel.updateNote(targetView.currentIndex, text, editorNoteContence.text)
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            TextArea {
                id: editorNoteContence
                placeholderText: "Start typing..."
                wrapMode: TextEdit.Wrap
                onTextChanged: {
                    if (activeFocus) {
                        notesModel.updateNote(targetView.currentIndex, editorNoteTitle.text, text)
                    }
                }
            }
        }
    }

    // 3. Footer with Save Button
    footer: ToolBar {
        background: Rectangle { color: "#eeeeee" }
        RowLayout {
            anchors.fill: parent
            Button {
                text: "Save Note"
                Layout.alignment: Qt.AlignHCenter
                enabled: hasSelection
                onClicked: {
                    // Logic for manual save or triggering C++ persistence
                    console.log("Saving note:", editorNoteTitle.text)
                    notesModel.updateNote(targetView.currentIndex, editorNoteTitle.text, editorNoteContence.text)

                    // Optional: Visual feedback
                    saveFeedback.start()
                }
            }
        }
    }

    SequentialAnimation {
        id: saveFeedback
        PropertyAnimation {
            target: editorBackground
            property: "color"
            from: "#f9f9f9"
            to: "#e0ffe0"
            duration: 200
        }
        PropertyAnimation {
            target: editorBackground
            property: "color"
            from: "#e0ffe0"
            to: "#f9f9f9"
            duration: 200
        }
    }
}