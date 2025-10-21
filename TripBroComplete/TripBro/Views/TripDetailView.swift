//
//  TripDetailView.swift
//  TripBro
//
//  Created by TripBro Team
//

import SwiftUI
import SwiftData

struct TripDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let trip: Trip

    @State private var documentCount = 0

    var body: some View {
        List {
            // Trip Info Section
            Section("Trip Information") {
                VStack(alignment: .leading, spacing: 8) {
                    Text(trip.name)
                        .font(.title2)
                        .fontWeight(.bold)

                    if let startDate = trip.startDate, let endDate = trip.endDate {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundStyle(.secondary)
                            Text("\(startDate.formatted(date: .abbreviated, time: .omitted)) - \(endDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    if let budget = trip.budget {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                                .foregroundStyle(.secondary)
                            Text("Budget: $\(budget as NSDecimalNumber)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.vertical, 4)

                if let notes = trip.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notes")
                            .font(.headline)
                        Text(notes)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }

            // Documents Section
            Section {
                NavigationLink {
                    DocumentListView(trip: trip)
                } label: {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundStyle(.blue)
                            .frame(width: 30)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Documents")
                                .font(.headline)
                            Text("\(documentCount) document\(documentCount == 1 ? "" : "s")")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Offline Storage")
            } footer: {
                Text("Store and access your trip documents offline")
            }

            // Additional Sections (placeholders for future features)
            Section("Itinerary") {
                Text("Coming soon")
                    .foregroundStyle(.secondary)
            }

            Section("Expenses") {
                Text("Coming soon")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle(trip.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            updateDocumentCount()
        }
    }

    private func updateDocumentCount() {
        do {
            let repository = DocumentRepository(modelContext: modelContext)
            let documents = try repository.fetchDocuments(for: trip)
            documentCount = documents.count
        } catch {
            print("Error fetching documents: \(error)")
        }
    }
}
