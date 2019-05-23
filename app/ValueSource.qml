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

import QtQuick 2.2
Item {
    id: valueSource

    property real kph: 0
    property bool mphDisplay: false
    property real speedScaling: mphDisplay == true ? 0.621 : 1.0
    property real rpm: 0
    property real fuel: 0
    property string gear: "P"
    property bool start: true
    property int turnSignal: -1
    property real temperature: 0

    property bool engineErr: true
    property bool oilErr: true
    property bool batteryErr: true

    property bool abs: true

    property bool seatBeltRow1Pos1: true
    property bool seatBeltRow1Pos2: true
    property bool seatBeltRow2Pos1: true
    property bool seatBeltRow2Pos2: true
    property bool seatBelt: seatBeltRow1Pos1 || seatBeltRow1Pos2 || seatBeltRow2Pos1 || seatBeltRow2Pos2

    property bool openDoorRow1Left: true
    property bool openDoorRow1Right: true
    property bool openDoorRow2Left: true
    property bool openDoorRow2Right: true
    property bool openTrunk: true
    property bool openBonnet: true
    property bool openDoor: openDoorRow1Left || openDoorRow1Right || openDoorRow2Left || openDoorRow2Right ||
        openTrunk || openBonnet

    property bool lightHasard: true
    property bool lightLowBeam: true
    property bool lightHighBeam: true
    property bool lightFronFog: true
    property bool lightRearFog: true
    property bool lights: lightHasard || lightLowBeam || lightHighBeam || lightFronFog || lightRearFog

    property bool parkingBrake: true

    Behavior on kph {
        NumberAnimation {
            duration: 1000
        }
    }

    Behavior on rpm {
        NumberAnimation {
            duration: 1000
        }
    }

    Timer {
        id: startupTimer
        interval: 2000
        running: true
        repeat: false
        onTriggered: {
            valueSource.engineErr = false
            visClient.connectTo(visUrl)
        }
    }

    Timer {
        id: reconnectTimer
        interval: 10000
        running: false
        repeat: true
        onTriggered: {
            visClient.connectTo(visUrl)
        }
    }

    Connections {
        target: visClient

        readonly property int stateInit: 0
        readonly property int stateGetValues: 1
        readonly property int stateSubscribe: 2
        readonly property int stateReady: 3

        property int state: stateInit
        property string requestId
        property string subscriptionId

        function generateUUID() {
            var d = new Date().getTime();
            var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
                var r = (d + Math.random() * 16) % 16 | 0
                d = Math.floor(d / 16)
                return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16)
            })
            return uuid;
        }

        onConnected: {
            console.log("Connected")

            reconnectTimer.stop()

            requestId = generateUUID()

            state = stateGetValues

            visClient.sendMessage(JSON.stringify({
                action: "get",
                path: "*",
                requestId: requestId
            }))
        }

        onError: {
            console.log("Error:", message)

            visClient.disconnect()
        }

        onDisconnected: {
            console.log("Disconnected")

            reconnectTimer.start()
        }

        onMessageReceived: {
            var jsonMessage = JSON.parse(message)

            if (jsonMessage.hasOwnProperty("requestId") && jsonMessage.requestId != requestId) {
                console.log("Unexpected request ID message received")
                return
            }

            if (jsonMessage.hasOwnProperty("error")) {
                console.log("Error:", jsonMessage.error.Message)
            }

            switch (state) {
                case stateGetValues: {
                    if (Array.isArray(jsonMessage.value)) {
                        jsonMessage.value.forEach(parseValue);
                    } else {
                        parseValue(jsonMessage.value)
                    }

                    requestId = generateUUID()

                    state = stateSubscribe

                    visClient.sendMessage(JSON.stringify({
                        action: "subscribe",
                        path: "*",
                        requestId: requestId
                    }))

                    break;
                }

                case stateSubscribe: {
                    subscriptionId = jsonMessage.subscriptionId

                    state = stateReady

                    console.log("subscriptionId:", jsonMessage.subscriptionId)

                    break;
                }

                case stateReady: {
                    if (jsonMessage.hasOwnProperty("subscriptionId") && jsonMessage.subscriptionId == subscriptionId) {
                        if (Array.isArray(jsonMessage.value)) {
                            jsonMessage.value.forEach(parseValue);
                        } else {
                            parseValue(jsonMessage.value)
                        }
                    } else {
                        console.log("Wrong subscription received:", jsonMessage.subscriptionId)
                    }

                    break;
                }

                default: {
                    console.log("Message received in wrong state")
                    break
                }
            }
        }
    }

    function parseValue(value) {
        // Speed
        if (value.hasOwnProperty("Signal.Vehicle.Speed")) {
            valueSource.kph = value["Signal.Vehicle.Speed"] / 1000
        }

        // Tacho
        if (value.hasOwnProperty("Signal.Drivetrain.InternalCombustionEngine.Engine.Speed")) {
            valueSource.rpm = value["Signal.Drivetrain.InternalCombustionEngine.Engine.Speed"] / 1000
        }

        // Gear
        if (value.hasOwnProperty("Signal.Drivetrain.Transmission.Gear")) {
            switch (value["Signal.Drivetrain.Transmission.Gear"]) {
                case -1:
                    valueSource.gear = "R"
                    break
                case 0:
                    valueSource.gear = "N"
                    break
                case 1:
                    valueSource.gear = "P"
                    break
                case 2:
                    valueSource.gear = "L"
                    break
                case 3:
                    valueSource.gear = "D"
                    break
            }
        }

        // Fuel
        if (value.hasOwnProperty("Signal.Drivetrain.FuelSystem.Level")) {
            valueSource.fuel = value["Signal.Drivetrain.FuelSystem.Level"] / 100.0
        }

        // Temperature
        if (value.hasOwnProperty("Signal.OBD.CoolantTemperature")) {
            valueSource.temperature = (value["Signal.OBD.CoolantTemperature"] - 70) / 40.0
        }

        // Turn signal
        if (value.hasOwnProperty("Signal.Traffic.Turn.Direction")) {
            switch (value["Signal.Traffic.Turn.Direction"]) {
                case "right":
                    valueSource.turnSignal = Qt.RightArrow
                    break

                case "left":
                    valueSource.turnSignal = Qt.LeftArrow
                    break

                default:
                    valueSource.turnSignal = -1
                    break
            }
        }

        // Seat belt
        if (value.hasOwnProperty("Signal.Cabin.Seat.Row1.Pos1.IsBelted")) {
            valueSource.seatBeltRow1Pos1 = !value["Signal.Cabin.Seat.Row1.Pos1.IsBelted"]
        }
        if (value.hasOwnProperty("Signal.Cabin.Seat.Row1.Pos2.IsBelted")) {
            valueSource.seatBeltRow1Pos2 = !value["Signal.Cabin.Seat.Row1.Pos2.IsBelted"]
        }
        if (value.hasOwnProperty("Signal.Cabin.Seat.Row2.Pos1.IsBelted")) {
            valueSource.seatBeltRow2Pos1 = !value["Signal.Cabin.Seat.Row2.Pos1.IsBelted"]
        }
        if (value.hasOwnProperty("Signal.Cabin.Seat.Row2.Pos2.IsBelted")) {
            valueSource.seatBeltRow2Pos2 = !value["Signal.Cabin.Seat.Row2.Pos2.IsBelted"]
        }

        // Door
        if (value.hasOwnProperty("Signal.Cabin.Door.Row1.Left.IsOpen")) {
            valueSource.openDoorRow1Left = value["Signal.Cabin.Door.Row1.Left.IsOpen"]
        }
        if (value.hasOwnProperty("Signal.Cabin.Door.Row1.Right.IsOpen")) {
            valueSource.openDoorRow1Right = value["Signal.Cabin.Door.Row1.Right.IsOpen"]
        }
        if (value.hasOwnProperty("Signal.Cabin.Door.Row2.Left.IsOpen")) {
            valueSource.openDoorRow2Left = value["Signal.Cabin.Door.Row2.Left.IsOpen"]
        }
        if (value.hasOwnProperty("Signal.Cabin.Door.Row2.Right.IsOpen")) {
            valueSource.openDoorRow2Right = value["Signal.Cabin.Door.Row2.Right.IsOpen"]
        }
        if (value.hasOwnProperty("Signal.Body.Hood.IsOpen")) {
            valueSource.openBonnet = value["Signal.Body.Hood.IsOpen"]
        }
        if (value.hasOwnProperty("Signal.Body.Trunk.IsOpen")) {
            valueSource.openTrunk = value["Signal.Body.Trunk.IsOpen"]
        }

        // Lights
        if (value.hasOwnProperty("Signal.Body.Lights.IsHazardOn")) {
            valueSource.lightHasard = value["Signal.Body.Lights.IsHazardOn"]
        }
        if (value.hasOwnProperty("Signal.Body.Lights.IsLowBeamOn")) {
            valueSource.lightLowBeam = value["Signal.Body.Lights.IsLowBeamOn"]
        }
        if (value.hasOwnProperty("Signal.Body.Lights.IsHighBeamOn")) {
            valueSource.lightHighBeam = value["Signal.Body.Lights.IsHighBeamOn"]
        }
        if (value.hasOwnProperty("Signal.Body.Lights.IsFrontFogOn")) {
            valueSource.lightFronFog = value["Signal.Body.Lights.IsFrontFogOn"]
        }
        if (value.hasOwnProperty("Signal.Body.Lights.IsRearFogOn")) {
            valueSource.lightRearFog = value["Signal.Body.Lights.IsRearFogOn"]
        }

        // Parking brake
        if (value.hasOwnProperty("Signal.Chassis.ParkingBrake.IsEngaged")) {
            valueSource.parkingBrake = value["Signal.Chassis.ParkingBrake.IsEngaged"]
        }

        // ABS
        if (value.hasOwnProperty("Signal.ADAS.ABS.IsEngaged")) {
            valueSource.abs = value["Signal.ADAS.ABS.IsEngaged"]
        }

        // Oil
        if (value.hasOwnProperty("Signal.OBD.OilLevel")) {
            if (value["Signal.OBD.OilLevel"] < 50) {
                valueSource.oilErr = true
            } else {
                valueSource.oilErr = false
            }
        }
        // Oil
        if (value.hasOwnProperty("Signal.OBD.OilLevel")) {
            if (value["Signal.OBD.OilLevel"] < 50) {
                valueSource.oilErr = true
            } else {
                valueSource.oilErr = false
            }
        }

        // Battery
        if (value.hasOwnProperty("Signal.Drivetrain.BatteryManagement.BatteryCapacity")) {
            if (value["Signal.Drivetrain.BatteryManagement.BatteryCapacity"] < 50) {
                valueSource.batteryErr = true
            } else {
                valueSource.batteryErr = false
            }
        }
    }
}