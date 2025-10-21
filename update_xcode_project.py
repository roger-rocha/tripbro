#!/usr/bin/env python3
"""
Script to add new Swift files to the Xcode project
"""

import re
import uuid

def generate_uuid():
    """Generate a random UUID in the format used by Xcode"""
    return uuid.uuid4().hex[:24].upper()

# Read the project file
with open('/home/user/tripbro/TripBroComplete/TripBro.xcodeproj/project.pbxproj', 'r') as f:
    content = f.read()

# New files to add
new_files = [
    {'name': 'Document.swift', 'path': 'Trip.swift'},
    {'name': 'DocumentRepository.swift', 'path': 'Trip.swift'},
    {'name': 'DocumentService.swift', 'path': 'Trip.swift'},
    {'name': 'DocumentListView.swift', 'path': 'TripListView.swift'},
    {'name': 'DocumentDetailView.swift', 'path': 'TripListView.swift'},
    {'name': 'DocumentPickerView.swift', 'path': 'TripListView.swift'},
    {'name': 'TripDetailView.swift', 'path': 'TripListView.swift'},
]

# Generate UUIDs for new files
file_references = {}
build_files = {}

for file_info in new_files:
    file_name = file_info['name']
    file_references[file_name] = generate_uuid()
    build_files[file_name] = generate_uuid()

# 1. Add PBXBuildFile section entries
build_file_section_match = re.search(r'(/\* Begin PBXBuildFile section \*/\n)', content)
if build_file_section_match:
    insert_pos = build_file_section_match.end()
    new_entries = []
    for file_name in file_references:
        new_entries.append(
            f"\t\t{build_files[file_name]} /* {file_name} in Sources */ = "
            f"{{isa = PBXBuildFile; fileRef = {file_references[file_name]} /* {file_name} */; }};\n"
        )
    content = content[:insert_pos] + ''.join(new_entries) + content[insert_pos:]

# 2. Add PBXFileReference section entries
file_ref_section_match = re.search(r'(/\* Begin PBXFileReference section \*/\n)', content)
if file_ref_section_match:
    insert_pos = file_ref_section_match.end()
    new_entries = []
    for file_name in file_references:
        new_entries.append(
            f"\t\t{file_references[file_name]} /* {file_name} */ = "
            f"{{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {file_name}; sourceTree = \"<group>\"; }};\n"
        )
    content = content[:insert_pos] + ''.join(new_entries) + content[insert_pos:]

# 3. Add files to PBXGroup (TripBro group)
group_section_match = re.search(r'(6A269C141BA24297B77212DD /\* TripBro \*/ = \{\s+isa = PBXGroup;\s+children = \(\s+)', content)
if group_section_match:
    insert_pos = group_section_match.end()
    new_entries = []
    for file_name in file_references:
        new_entries.append(f"\t\t\t\t{file_references[file_name]} /* {file_name} */,\n")
    content = content[:insert_pos] + ''.join(new_entries) + content[insert_pos:]

# 4. Add to PBXSourcesBuildPhase
sources_section_match = re.search(r'(8AE8A754C1424BAA82640DA4 /\* Sources \*/ = \{\s+isa = PBXSourcesBuildPhase;\s+buildActionMask = 2147483647;\s+files = \(\s+)', content)
if sources_section_match:
    insert_pos = sources_section_match.end()
    new_entries = []
    for file_name in file_references:
        new_entries.append(f"\t\t\t\t{build_files[file_name]} /* {file_name} in Sources */,\n")
    content = content[:insert_pos] + ''.join(new_entries) + content[insert_pos:]

# Write the updated project file
with open('/home/user/tripbro/TripBroComplete/TripBro.xcodeproj/project.pbxproj', 'w') as f:
    f.write(content)

print("Successfully updated Xcode project file with new Swift files")
for file_name in file_references:
    print(f"  - {file_name}")
