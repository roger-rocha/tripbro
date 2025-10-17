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
