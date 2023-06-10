QT += \
    quick \
    qml \
    widgets

CONFIG += c++17 cmdline


# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += \
        main.cpp \
        myclass.cpp \
        restaccessmanager.cpp \
        restservice.cpp \
        mediaresource.cpp \
        util.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
        myclass.h \
        restaccessmanager.h \
        restservice.h \
        mediaresource.h \
        util.h

