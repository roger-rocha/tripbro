#!/usr/bin/env python3

import os
import uuid
import plistlib

def generate_uuid():
    """Generate a 24-character hex UUID for Xcode"""
    return uuid.uuid4().hex[:24].upper()

def create_pbxproj():
    """Generate a complete project.pbxproj with all source files"""

    # Get all Swift files
    swift_files = []
    for root, dirs, files in os.walk('TripBro'):
        for file in files:
            if file.endswith('.swift'):
                path = os.path.join(root, file)
                swift_files.append(path)

    # Generate UUIDs for everything
    project_uuid = generate_uuid()
    target_uuid = generate_uuid()
    sources_phase_uuid = generate_uuid()
    frameworks_phase_uuid = generate_uuid()
    resources_phase_uuid = generate_uuid()
    build_config_debug_uuid = generate_uuid()
    build_config_release_uuid = generate_uuid()
    config_list_project_uuid = generate_uuid()
    config_list_target_uuid = generate_uuid()
    product_uuid = generate_uuid()
    main_group_uuid = generate_uuid()
    products_group_uuid = generate_uuid()

    # File references and build files
    file_refs = {}
    build_files = {}

    for swift_file in swift_files:
        file_uuid = generate_uuid()
        build_uuid = generate_uuid()
        file_refs[swift_file] = file_uuid
        build_files[swift_file] = build_uuid

    # Generate the project file content
    content = f"""// !$*UTF8*$!
{{
	archiveVersion = 1;
	classes = {{}};
	objectVersion = 56;
	objects = {{

/* Begin PBXBuildFile section */"""

    # Add build files
    for path, build_uuid in build_files.items():
        file_uuid = file_refs[path]
        filename = os.path.basename(path)
        content += f"""
		{build_uuid} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_uuid} /* {filename} */; }};"""

    content += """
/* End PBXBuildFile section */

/* Begin PBXFileReference section */"""

    # Add file references
    content += f"""
		{product_uuid} /* TripBro.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = TripBro.app; sourceTree = BUILT_PRODUCTS_DIR; }};"""

    for path, file_uuid in file_refs.items():
        filename = os.path.basename(path)
        content += f"""
		{file_uuid} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "{path.replace('TripBro/', '')}"; sourceTree = "<group>"; }};"""

    content += f"""
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		{frameworks_phase_uuid} /* Frameworks */ = {{
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		{main_group_uuid} = {{
			isa = PBXGroup;
			children = (
				{generate_uuid()} /* TripBro */,
				{products_group_uuid} /* Products */,
			);
			sourceTree = "<group>";
		}};
		{products_group_uuid} /* Products */ = {{
			isa = PBXGroup;
			children = (
				{product_uuid} /* TripBro.app */,
			);
			name = Products;
			sourceTree = "<group>";
		}};
		{generate_uuid()} /* TripBro */ = {{
			isa = PBXGroup;
			children = ("""

    # Add file references to group
    for path in file_refs.values():
        content += f"""
				{path},"""

    content += f"""
			);
			path = TripBro;
			sourceTree = "<group>";
		}};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		{target_uuid} /* TripBro */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {config_list_target_uuid};
			buildPhases = (
				{sources_phase_uuid} /* Sources */,
				{frameworks_phase_uuid} /* Frameworks */,
				{resources_phase_uuid} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = TripBro;
			productName = TripBro;
			productReference = {product_uuid} /* TripBro.app */;
			productType = "com.apple.product-type.application";
		}};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		{project_uuid} /* Project object */ = {{
			isa = PBXProject;
			attributes = {{
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeVersion = 1500;
				TargetAttributes = {{
					{target_uuid} = {{
						CreatedOnToolsVersion = 15.0;
					}};
				}};
			}};
			buildConfigurationList = {config_list_project_uuid};
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = {main_group_uuid};
			productRefGroup = {products_group_uuid} /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				{target_uuid} /* TripBro */,
			);
		}};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		{resources_phase_uuid} /* Resources */ = {{
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		{sources_phase_uuid} /* Sources */ = {{
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = ("""

    # Add all source files to compile
    for path, build_uuid in build_files.items():
        filename = os.path.basename(path)
        content += f"""
				{build_uuid} /* {filename} in Sources */,"""

    content += f"""
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		{build_config_debug_uuid} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.tripbro.app;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Debug;
		}};
		{build_config_release_uuid} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				VALIDATE_PRODUCT = YES;
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.tripbro.app;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Release;
		}};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		{config_list_project_uuid} = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{build_config_debug_uuid} /* Debug */,
				{build_config_release_uuid} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
		{config_list_target_uuid} = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{build_config_debug_uuid} /* Debug */,
				{build_config_release_uuid} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
/* End XCConfigurationList section */
	}};
	rootObject = {project_uuid} /* Project object */;
}}
"""

    return content

if __name__ == "__main__":
    # Copy all the source files from the existing TripBro directory
    os.system("cp -r /Users/rogerrocha/Developer/Personal/TripBro/.conductor/salvador/TripBro/TripBro TripBroFinal/")
    os.chdir("TripBroFinal")

    # Create the Xcode project
    os.makedirs("TripBro.xcodeproj", exist_ok=True)

    # Generate and write the project file
    pbxproj_content = create_pbxproj()
    with open("TripBro.xcodeproj/project.pbxproj", "w") as f:
        f.write(pbxproj_content)

    print("✅ Complete Xcode project generated with ALL source files!")
    print("📂 Project location: TripBroFinal/TripBro.xcodeproj")
    print("🚀 Open in Xcode and hit Run!")