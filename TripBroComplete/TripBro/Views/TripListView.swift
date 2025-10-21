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
                    NavigationLink {
                        TripDetailView(trip: trip)
                    } label: {
                        TripRowView(trip: trip)
                    }
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
