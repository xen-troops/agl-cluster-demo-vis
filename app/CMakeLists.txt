###########################################################################
# Copyright 2018 Konsulko Group
#
# Author: Scott Murray <scott.murray@konsulko.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###########################################################################

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 14)

find_package(Qt5 COMPONENTS Core Gui QuickControls2 WebSockets QuickWidgets DBus REQUIRED)
find_package(PkgConfig REQUIRED)

qt5_add_resources(RESOURCES cluster-gauges.qrc images/images.qrc)

PROJECT_TARGET_ADD(cluster-gauges)

add_executable(${TARGET_NAME}
	main.cpp
	VisClient.cpp
	VisClient.hpp
	DisplayManagerClient.hpp
	${RESOURCES}
)

pkg_check_modules(QLIBWINMGR REQUIRED qlibwindowmanager)

set_target_properties(${TARGET_NAME} PROPERTIES
	LABELS "EXECUTABLE"
	PREFIX ""
	COMPILE_FLAGS "${QLIBWINMGR_FLAGS} ${EXTRAS_CFLAGS} -DFOR_AFB_BINDING"
	LINK_FLAGS "${BINDINGS_LINK_FLAG}"
	LINK_LIBRARIES "${EXTRAS_LIBRARIES}"
	OUTPUT_NAME "${TARGET_NAME}"
)

target_link_libraries(${TARGET_NAME}
	Qt5::QuickControls2
	Qt5::QuickWidgets
	Qt5::WebSockets
	Qt5::DBus
	${QLIBWINMGR_LIBRARIES}
)
