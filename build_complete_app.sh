#!/bin/bash

echo "🚀 Building Complete TripBro iOS App..."

cd TripBroComplete

# Create the complete app structure
mkdir -p TripBro.xcodeproj
mkdir -p TripBro
mkdir -p TripBro/App
mkdir -p TripBro/Models
mkdir -p TripBro/Views
mkdir -p TripBro/ViewModels
mkdir -p TripBro/Services
mkdir -p TripBro/Resources

# Create a simple but complete multi-file iOS app

# 1. Main App File
cat > TripBro/App/TripBroApp.swift << 'EOF'
import SwiftUI
import SwiftData

@main
struct TripBroApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Trip.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
EOF

# 2. Content View
cat > TripBro/Views/ContentView.swift << 'EOF'
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TripListView()
                .tabItem {
                    Label("Trips", systemImage: "suitcase.fill")
                }

            Text("Discover")
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }

            Text("Stats")
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }

            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.orange)
    }
}

#Preview {
    ContentView()
}
EOF

# 3. Trip Model
cat > TripBro/Models/Trip.swift << 'EOF'
import Foundation
import SwiftData

@Model
final class Trip {
    var id: UUID
    var name: String
    var startDate: Date?
    var endDate: Date?
    var notes: String?
    var budget: Decimal?
    var createdAt: Date

    init(name: String, startDate: Date? = nil, endDate: Date? = nil) {
        self.id = UUID()
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.createdAt = Date()
    }
}
EOF

# 4. Trip List View
cat > TripBro/Views/TripListView.swift << 'EOF'
import SwiftUI
import SwiftData

struct TripListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var trips: [Trip]
    @State private var showingAddTrip = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(trips) { trip in
                    TripRowView(trip: trip)
                }
                .onDelete(perform: deleteTrips)
            }
            .navigationTitle("My Trips")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTrip = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTrip) {
                AddTripView()
            }
            .overlay {
                if trips.isEmpty {
                    ContentUnavailableView(
                        "No Trips",
                        systemImage: "suitcase",
                        description: Text("Tap + to add your first trip")
                    )
                }
            }
        }
    }

    private func deleteTrips(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(trips[index])
            }
        }
    }
}
EOF

# 5. Trip Row View
cat > TripBro/Views/TripRowView.swift << 'EOF'
import SwiftUI

struct TripRowView: View {
    let trip: Trip

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(trip.name)
                .font(.headline)

            if let startDate = trip.startDate {
                Text(startDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
EOF

# 6. Add Trip View
cat > TripBro/Views/AddTripView.swift << 'EOF'
import SwiftUI
import SwiftData

struct AddTripView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var hasStartDate = false
    @State private var hasEndDate = false
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Trip Details") {
                    TextField("Trip Name", text: $name)

                    Toggle("Set Start Date", isOn: $hasStartDate)
                    if hasStartDate {
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    }

                    Toggle("Set End Date", isOn: $hasEndDate)
                    if hasEndDate {
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                    }
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(4...8)
                }
            }
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addTrip()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    private func addTrip() {
        let newTrip = Trip(
            name: name,
            startDate: hasStartDate ? startDate : nil,
            endDate: hasEndDate ? endDate : nil
        )
        newTrip.notes = notes.isEmpty ? nil : notes

        modelContext.insert(newTrip)
        dismiss()
    }
}
EOF

# Create Info.plist
cat > TripBro/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
</dict>
</plist>
EOF

echo "✅ All source files created!"
echo "📦 Now generating Xcode project file..."

# Now create the pbxproj file using the Python script
python3 ../generate_complete_xcode_project.py

echo "🎉 Complete TripBro app ready!"
echo "📂 Location: TripBroComplete/TripBro.xcodeproj"
echo "🚀 Open in Xcode and run!"