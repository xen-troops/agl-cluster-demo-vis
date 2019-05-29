TARGET = cluster-gauges
QT = quickcontrols2 websockets dbus

DEFINES = HOST_BUILD

HEADERS = VisClient.hpp \
    DisplayManagerClient.hpp

SOURCES = main.cpp \
    VisClient.cpp

RESOURCES += \
    cluster-gauges.qrc \
    images/images.qrc
