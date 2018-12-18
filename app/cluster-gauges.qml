/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Copyright (C) 2018 Konsulko Group
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

/*
 * NOTE: Originally written from scratch, but enough code was eventually
 *       pasted in from the Qt dashboard.qml example that its license text
 *       has been adopted.
 */

import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

ApplicationWindow {
    id: root
    width: 1920
    height: 1080
    visible: true
    flags: Qt.FramelessWindowHint
    style: ApplicationWindowStyle {
        background: Rectangle {
            color: "black"
        }
    }

    ValueSource {
        id: valueSource
    }

    Rectangle {
        id: statusFrame
        x: (parent.width - width) / 2
        y: 80
        width: 1152
        height: 96
        radius: height / 5

        color: "black"
        border.width: 2
        border.color: "grey"

        Row {
            width: parent.width
            height: parent.height * 0.75
            spacing: (parent.width - (12 * parent.height * 0.75)) / 13

            anchors.fill: parent
            anchors.topMargin: (parent.height - height) /2
            anchors.bottomMargin: (parent.height - height) /2
            anchors.leftMargin: (parent.width - (12 * parent.height * 0.75)) / 13
            anchors.rightMargin: (parent.width - (12 * parent.height * 0.75)) / 13

            Rectangle {
                width: height
                height: parent.height
                radius: height / 5

                color: "black"
                border.width: 2
                border.color: "grey"

                TurnIndicator {
                    id: leftIndicator
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: height
                    height: parent.height * 0.75

                    direction: Qt.LeftArrow
                    on: valueSource.turnSignal == Qt.LeftArrow
                }
            }

            Rectangle {
                width: height
                height: parent.height
                radius: height / 5

                color: "black"
                border.width: 2
                border.color: "grey"

                Image {
                    source: valueSource.startUp ? './images/AGL_Icons_Engine_yellow.svg' : './images/AGL_Icons_Engine.svg'
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: height
                    height: parent.height * 0.75
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                width: height
                height: parent.height
                radius: height / 5

                color: "black"
                border.width: 2
                border.color: "grey"

                Image {
                    source: valueSource.startUp ? './images/AGL_Icons_Oil_red.svg' : './images/AGL_Icons_Oil.svg'
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: height
                    height: parent.height * 0.75
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                width: height
                height: parent.height
                radius: height / 5

                color: "black"
                border.width: 2
                border.color: "grey"

                Image {
                    source: valueSource.startUp ? './images/AGL_Icons_ABS_red.svg' : './images/AGL_Icons_ABS.svg'
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: height
                    height: parent.height * 0.75
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                width: height
                height: parent.height
                radius: height / 5

                color: "black"
                border.width: 2
                border.color: "grey"

                Image {
                    source: valueSource.startUp ? './images/AGL_Icons_Battery_red.svg' : './images/AGL_Icons_Battery.svg'
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: height
                    height: parent.height * 0.75
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                width: height
                height: parent.height
                radius: height / 5

                color: "black"
                border.width: 2
                border.color: "grey"

                Text {
                    id: prindle
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignCenter

                    text: valueSource.prindle
                    color: "white"
                    font.pixelSize: parent.height * 0.85
                }
            }

            Rectangle {
                id: gearIndicatior
                width: height
                height: parent.height
                radius: height / 5

                color: "black"
                border.width: 2
                border.color: "grey"

                Text {
                    id: gear
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignCenter

                    text: valueSource.gear
                    color: "white"
                    font.pixelSize: parent.height * 0.85
                }
            }

            Rectangle {
                width: height
                height: parent.height
                radius: height / 5

                color: "black"
                border.width: 2
                border.color: "grey"

                Image {
                    source: valueSource.startUp ? './images/AGL_Icons_Seatbelt_red.svg' : './images/AGL_Icons_Seatbelt.svg'
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: height
                    height: parent.height * 0.75
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                width: height
                height: parent.height
                radius: height / 5

                color: "black"
                border.width: 2
                border.color: "grey"

                Image {
                    source: valueSource.startUp ? './images/AGL_Icons_OpenDoor_red.svg' : './images/AGL_Icons_OpenDoor.svg'
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: height
                    height: parent.height * 0.75
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                width: height
                height: parent.height
                radius: height / 5

                color: "black"
                border.width: 2
                border.color: "grey"

                Image {
                    source: valueSource.startUp ? './images/AGL_Icons_Lights_red.svg' : './images/AGL_Icons_Lights.svg'
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: height
                    height: parent.height * 0.75
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                width: height
                height: parent.height
                radius: height / 5

                color: "black"
                border.width: 2
                border.color: "grey"

                Image {
                    source: valueSource.startUp ? './images/AGL_Icons_ParkingBrake_red.svg' : './images/AGL_Icons_ParkingBrake.svg'
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: height
                    height: parent.height * 0.75
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                width: height
                height: parent.height
                radius: height / 5

                color: "black"
                border.width: 2
                border.color: "grey"

                TurnIndicator {
                    id: rightIndicator
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: height
                    height: parent.height * 0.75

                    direction: Qt.RightArrow
                    on: valueSource.turnSignal == Qt.RightArrow
                }
            }
        }
    }

    Item {
        x: 36
        y: 240
        width: 600
        height: width

        CircularGauge {
            id: accelerometer
            x: (parent.width - width) / 2
            //y: (parent.height - height) / 2
            width: parent.width * 0.9
            height: width

            maximumValue: valueSource.mphDisplay ? 140 : 220
            value: valueSource.kph * valueSource.speedScaling

            style: DashboardGaugeStyle {}
        }
    }

    Item {
        x: 1284
        y: 240
        width: 600
        height: width

        CircularGauge {
            id: tachometer
            x: (parent.width - width) / 2
            width: parent.width * 0.9
            height: width

            maximumValue: 8
            value: valueSource.rpm

            style: TachometerStyle {}
        }

        CircularGauge {
            id: fuelGauge
            value: valueSource.fuel
            maximumValue: 1
            y: parent.width * 0.85
            width: parent.width * 0.45
            height: parent.height * 0.25

            style: IconGaugeStyle {
                id: fuelGaugeStyle

                icon: "./images/fuel-icon.png"
                minWarningColor: Qt.rgba(0.5, 0, 0, 1)

                tickmarkLabel: Text {
                    color: "white"
                    visible: styleData.value === 0 || styleData.value === 1
                    font.pixelSize: fuelGaugeStyle.toPixels(0.225)
                    text: styleData.value === 0 ? "E" : (styleData.value === 1 ? "F" : "")
                }
            }
        }

	CircularGauge {
            id: tempGauge
            value: valueSource.temperature
            maximumValue: 1
            x: parent.width * 0.55
            y: parent.width * 0.85
            width: parent.width * 0.45
            height: parent.height * 0.25

            style: IconGaugeStyle {
                id: tempGaugeStyle

                icon: "./images/temperature-icon.png"
                maxWarningColor: Qt.rgba(0.5, 0, 0, 1)

                tickmarkLabel: Text {
                    color: "white"
                    visible: styleData.value === 0 || styleData.value === 1
                    font.pixelSize: tempGaugeStyle.toPixels(0.225)
                    text: styleData.value === 0 ? "C" : (styleData.value === 1 ? "H" : "")
                }
            }
        }
    }

    Rectangle {
        id: frame
        x: 672
        y: 264
        width: 576
        height: 552

        color: "black"
        border.width: 4
        border.color: "grey"

        Image {
            source: './images/Utility_Logo_Grey-01.svg'
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: parent.width / 2
            height: width
        }
    }

    Image {
        source: './images/agl_title_793x211.png'
        //x: 772
        x: (parent.width - width) / 2
        y: 898
        width: 376
        height: 100
    }
}
