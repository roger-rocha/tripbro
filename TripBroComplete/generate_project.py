#!/usr/bin/env python3

import os
import uuid

def generate_uuid():
    """Generate a 24-character hex UUID for Xcode"""
    return uuid.uuid4().hex[:24].upper()

# Find all Swift files
swift_files = []
for root, dirs, files in os.walk('TripBro'):
    for file in files:
        if file.endswith('.swift'):
            path = os.path.join(root, file)
            swift_files.append(path.replace('TripBro/', ''))

print(f"Found {len(swift_files)} Swift files")

# Generate UUIDs
project_uuid = generate_uuid()
target_uuid = generate_uuid()
sources_uuid = generate_uuid()
frameworks_uuid = generate_uuid()
resources_uuid = generate_uuid()
main_group_uuid = generate_uuid()
products_group_uuid = generate_uuid()
app_group_uuid = generate_uuid()
product_ref_uuid = generate_uuid()
build_config_list_project = generate_uuid()
build_config_list_target = generate_uuid()
build_config_debug = generate_uuid()
build_config_release = generate_uuid()

# Generate file references and build files
file_refs = {}
build_files = {}
for swift_file in swift_files:
    file_refs[swift_file] = generate_uuid()
    build_files[swift_file] = generate_uuid()

# Generate project.pbxproj
content = f"""// !$*UTF8*$!
{{
	archiveVersion = 1;
	classes = {{}};
	objectVersion = 56;
	objects = {{

/* Begin PBXBuildFile section */"""

for swift_file in swift_files:
    name = os.path.basename(swift_file)
    content += f"""
		{build_files[swift_file]} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_refs[swift_file]} /* {name} */; }};"""

content += """
/* End PBXBuildFile section */

/* Begin PBXFileReference section */"""

content += f"""
		{product_ref_uuid} /* TripBro.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = TripBro.app; sourceTree = BUILT_PRODUCTS_DIR; }};"""

for swift_file in swift_files:
    name = os.path.basename(swift_file)
    content += f"""
		{file_refs[swift_file]} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {name}; sourceTree = "<group>"; }};"""

content += f"""
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		{frameworks_uuid} /* Frameworks */ = {{
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
				{app_group_uuid} /* TripBro */,
				{products_group_uuid} /* Products */,
			);
			sourceTree = "<group>";
		}};
		{products_group_uuid} /* Products */ = {{
			isa = PBXGroup;
			children = (
				{product_ref_uuid} /* TripBro.app */,
			);
			name = Products;
			sourceTree = "<group>";
		}};
		{app_group_uuid} /* TripBro */ = {{
			isa = PBXGroup;
			children = ("""

# Add file references to group
for swift_file in swift_files:
    content += f"""
				{file_refs[swift_file]} /* {os.path.basename(swift_file)} */,"""

content += f"""
			);
			path = TripBro;
			sourceTree = "<group>";
		}};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		{target_uuid} /* TripBro */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {build_config_list_target};
			buildPhases = (
				{sources_uuid} /* Sources */,
				{frameworks_uuid} /* Frameworks */,
				{resources_uuid} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = TripBro;
			productName = TripBro;
			productReference = {product_ref_uuid} /* TripBro.app */;
			productType = "com.apple.product-type.application";
		}};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		{project_uuid} /* Project object */ = {{
			isa = PBXProject;
			attributes = {{
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
				TargetAttributes = {{
					{target_uuid} = {{
						CreatedOnToolsVersion = 15.0;
					}};
				}};
			}};
			buildConfigurationList = {build_config_list_project};
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
		{resources_uuid} /* Resources */ = {{
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		{sources_uuid} /* Sources */ = {{
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = ("""

for swift_file in swift_files:
    content += f"""
				{build_files[swift_file]} /* {os.path.basename(swift_file)} in Sources */,"""

content += f"""
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		{build_config_debug} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			}};
			name = Debug;
		}};
		{build_config_release} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
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
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				VALIDATE_PRODUCT = YES;
			}};
			name = Release;
		}};
		{generate_uuid()} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
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
		{generate_uuid()} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
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
		{build_config_list_project} = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{build_config_debug} /* Debug */,
				{build_config_release} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
		{build_config_list_target} = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{generate_uuid()} /* Debug */,
				{generate_uuid()} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
/* End XCConfigurationList section */
	}};
	rootObject = {project_uuid} /* Project object */;
}}
"""

# Create Xcode project directory and write the file
os.makedirs("TripBro.xcodeproj", exist_ok=True)
with open("TripBro.xcodeproj/project.pbxproj", "w") as f:
    f.write(content)

print("✅ Xcode project generated successfully!")
print("📂 All Swift files included in build phase")
print("🚀 Ready to open in Xcode and build!")