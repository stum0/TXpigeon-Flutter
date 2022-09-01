
 find_package(Corrosion REQUIRED)


corrosion_import_crate(MANIFEST_PATH ../rust/Cargo.toml)

# Flutter-specific

set(CRATE_NAME "rust")

target_link_libraries(${BINARY_NAME} PRIVATE ${CRATE_NAME})

list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${CRATE_NAME}-shared>)
