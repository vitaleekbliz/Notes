cmake_minimum_required(VERSION 3.16)

project(Notes VERSION 0.1 LANGUAGES CXX) 

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.10)


qt_add_executable(appNotes
    src/main.cpp
    src/Application.cpp
    src/Application.h
    src/Notes/NotesModel.cpp
    src/Notes/NotesModel.h
)

qt_add_qml_module(appNotes
    URI Notes
    VERSION 1.0
    QML_FILES 
        src/Main.qml
        src/Notes/NotesEditor/NotesEditor.qml
        src/Notes/NotesList/NotesList.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appNotes PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appNotes
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appNotes
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Core
    PRIVATE Qt6::Qml
)

target_include_directories(appNotes PRIVATE src)


install(TARGETS appNotes
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
