TARGET = cluster-gauges
QT = quickcontrols2 websockets

DEFINES = HOST_BUILD

HEADERS = visclient.h

SOURCES = main.cpp \
    visclient.cpp

RESOURCES += \
    cluster-gauges.qrc \
    images/images.qrc