TARGET = cluster-gauges
QT = quickcontrols2 websockets

DEFINES = HOST_BUILD

HEADERS = VisClient.hpp

SOURCES = main.cpp \
    VisClient.cpp

RESOURCES += \
    cluster-gauges.qrc \
    images/images.qrc
