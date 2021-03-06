add_definitions(-DHRPSYS_PACKAGE_VERSION=\"\\"${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}\\"\")

# hrpIo
add_library(hrpIo_gazebo SHARED iob.cpp)
add_dependencies(hrpIo_gazebo hrpsys_gazebo_msgs_gencpp)

if (NOT APPLE AND NOT QNXNTO)
   target_link_libraries(hrpIo_gazebo rt)
endif()

target_link_libraries(hrpIo_gazebo roscpp rostime)

# RobotHardware
set(comp_source  ${ROBOTHARDWARE_SOURCE}/robot.cpp ${ROBOTHARDWARE_SOURCE}/RobotHardware.cpp ${ROBOTHARDWARE_SOURCE}/RobotHardwareService_impl.cpp)
set(libs hrpIo_gazebo hrpModel-3.1 hrpCollision-3.1 hrpUtil-3.1 hrpsysBaseStub)

add_library(RobotHardware_gazebo SHARED ${comp_source})

target_link_libraries(RobotHardware_gazebo  ${libs})
set_target_properties(RobotHardware_gazebo PROPERTIES PREFIX "")
set_target_properties(RobotHardware_gazebo PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)
set_target_properties(RobotHardware_gazebo PROPERTIES OUTPUT_NAME RobotHardware)

add_executable(RobotHardwareComp_gazebo ${ROBOTHARDWARE_SOURCE}/RobotHardwareComp.cpp ${comp_source})
target_link_libraries(RobotHardwareComp_gazebo ${libs} ${omniorb_LIBRARIES} ${omnidynamic_LIBRARIES} RTC coil dl pthread)
set_target_properties(RobotHardwareComp_gazebo PROPERTIES OUTPUT_NAME RobotHardwareComp)

add_library(hrpEC_gazebo SHARED ${HRPEC_SOURCE}/hrpEC.cpp ${HRPEC_SOURCE}/hrpEC-common.cpp)
target_link_libraries(hrpEC_gazebo hrpIo_gazebo hrpsysBaseStub)
set_target_properties(hrpEC_gazebo PROPERTIES PREFIX "")
set_target_properties(hrpEC_gazebo PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)
set_target_properties(hrpEC_gazebo PROPERTIES OUTPUT_NAME hrpEC)
set_target_properties(hrpEC_gazebo PROPERTIES COMPILE_DEFINITIONS "OPENRTM_VERSION110")


install(TARGETS hrpIo_gazebo
  LIBRARY DESTINATION lib CONFIGURATIONS Release Debug RelWithDebInfo
)
install(TARGETS RobotHardwareComp_gazebo RobotHardware_gazebo hrpEC_gazebo
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION} CONFIGURATIONS Release Debug RelWithDebInfo
  LIBRARY DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/lib CONFIGURATIONS Release Debug RelWithDebInfo
)



