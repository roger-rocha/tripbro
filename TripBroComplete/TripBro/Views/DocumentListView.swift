//
//  DocumentListView.swift
//  TripBro
//
//  Created by TripBro Team
//

import SwiftUI
import SwiftData

struct DocumentListView: View {
    @Environment(\.modelContext) private var modelContext
    let trip: Trip

    @State private var documents: [Document] = []
    @State private var showingDocumentPicker = false
    @State private var showingAddNoteSheet = false
    @State private var selectedDocument: Document?
    @State private var errorMessage: String?
    @State private var showingError = false

    private var documentService: DocumentService {
        DocumentService(repository: DocumentRepository(modelContext: modelContext))
    }

    var body: some View {
        List {
            if documents.isEmpty {
                ContentUnavailableView(
                    "No Documents",
                    systemImage: "doc.text",
                    description: Text("Add documents to your trip to access them offline")
                )
            } else {
                ForEach(documents) { document in
                    DocumentRowView(document: document)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedDocument = document
                        }
                }
                .onDelete(perform: deleteDocuments)
            }
        }
        .navigationTitle("Documents")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        showingDocumentPicker = true
                    } label: {
                        Label("Add File", systemImage: "doc.badge.plus")
                    }

                    Button {
                        showingAddNoteSheet = true
                    } label: {
                        Label("Add Note", systemImage: "note.text.badge.plus")
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingDocumentPicker) {
            DocumentPickerView(trip: trip) { result in
                handleDocumentPickerResult(result)
            }
        }
        .sheet(isPresented: $showingAddNoteSheet) {
            AddNoteView(trip: trip) {
                loadDocuments()
            }
        }
        .sheet(item: $selectedDocument) { document in
            NavigationStack {
                DocumentDetailView(document: document)
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "An unknown error occurred")
        }
        .onAppear {
            loadDocuments()
        }
    }

    private func loadDocuments() {
        do {
            documents = try documentService.fetchDocuments(for: trip)
        } catch {
            errorMessage = "Failed to load documents: \(error.localizedDescription)"
            showingError = true
        }
    }

    private func deleteDocuments(at offsets: IndexSet) {
        for index in offsets {
            let document = documents[index]
            documentService.deleteDocument(document)
        }
        loadDocuments()
    }

    private func handleDocumentPickerResult(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            do {
                _ = try documentService.createDocument(
                    from: url,
                    title: url.deletingPathExtension().lastPathComponent,
                    trip: trip
                )
                loadDocuments()
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
}

// MARK: - Document Row View

struct DocumentRowView: View {
    let document: Document

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: document.type.icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            // Document info
            VStack(alignment: .leading, spacing: 4) {
                Text(document.title)
                    .font(.headline)

                HStack(spacing: 8) {
                    Text(document.type.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("•")
                        .foregroundStyle(.secondary)

                    Text(document.formattedFileSize)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if document.isAvailableOffline {
                        Text("•")
                            .foregroundStyle(.secondary)

                        HStack(spacing: 2) {
                            Image(systemName: "arrow.down.circle.fill")
                            Text("Offline")
                        }
                        .font(.caption)
                        .foregroundStyle(.green)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
