cmake_minimum_required(VERSION 3.24)

project(Notes VERSION 0.1 LANGUAGES CXX) 

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.10 QUIET COMPONENTS Quick Core Qml)


if(NOT Qt6_FOUND)
    message(STATUS "Local Qt not found. Falling back to FetchContent (this will take a while...)")
    include(FetchContent)
    FetchContent_Declare(
        Qt6
        GIT_REPOSITORY https://github.com/qt/qt5.git
        GIT_TAG v6.10.0
        GIT_PROGRESS TRUE
    )
    # Optimization: Disable everything we don't need to speed up build
    set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
    set(BUILD_TESTS OFF CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(Qt6)
else()
    message(STATUS "Found local Qt installation: ${Qt6_DIR}")
endif()

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

if(WIN32)
    qt_generate_deploy_app_script(
        TARGET appNotes
        OUTPUT_SCRIPT deploy_script
        NO_TRANSLATIONS # Optional: saves space
    )
    install(SCRIPT ${deploy_script})
endif()