//
//  DocumentPickerView.swift
//  TripBro
//
//  Created by TripBro Team
//

import SwiftUI
import UniformTypeIdentifiers
import PhotosUI

struct DocumentPickerView: View {
    @Environment(\.dismiss) private var dismiss
    let trip: Trip
    let onComplete: (Result<URL, Error>) -> Void

    @State private var showingFilePicker = false
    @State private var showingPhotoPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        showingPhotoPicker = true
                    } label: {
                        Label("Choose from Photos", systemImage: "photo.on.rectangle")
                    }

                    Button {
                        showingFilePicker = true
                    } label: {
                        Label("Choose from Files", systemImage: "folder")
                    }
                }
            }
            .navigationTitle("Add Document")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: [.pdf, .image, .plainText, .item],
                allowsMultipleSelection: false
            ) { result in
                handleFilePickerResult(result)
            }
            .photosPicker(
                isPresented: $showingPhotoPicker,
                selection: $selectedPhotoItem,
                matching: .images
            )
            .onChange(of: selectedPhotoItem) { _, newItem in
                handlePhotoPickerSelection(newItem)
            }
        }
    }

    private func handleFilePickerResult(_ result: Result<[URL], Error>) {
        dismiss()
        switch result {
        case .success(let urls):
            if let url = urls.first {
                // Start accessing the security-scoped resource
                if url.startAccessingSecurityScopedResource() {
                    defer { url.stopAccessingSecurityScopedResource() }
                    onComplete(.success(url))
                } else {
                    onComplete(.failure(DocumentPickerError.accessDenied))
                }
            }
        case .failure(let error):
            onComplete(.failure(error))
        }
    }

    private func handlePhotoPickerSelection(_ item: PhotosPickerItem?) {
        guard let item = item else { return }

        Task {
            do {
                if let data = try await item.loadTransferable(type: Data.self) {
                    // Save to temporary file
                    let tempURL = FileManager.default.temporaryDirectory
                        .appendingPathComponent(UUID().uuidString)
                        .appendingPathExtension("jpg")

                    try data.write(to: tempURL)

                    await MainActor.run {
                        dismiss()
                        onComplete(.success(tempURL))
                    }
                }
            } catch {
                await MainActor.run {
                    dismiss()
                    onComplete(.failure(error))
                }
            }
        }
    }
}

enum DocumentPickerError: LocalizedError {
    case accessDenied

    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Access to the file was denied"
        }
    }
}

// MARK: - Add Note View

struct AddNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let trip: Trip
    let onComplete: () -> Void

    @State private var title = ""
    @State private var content = ""

    private var isValid: Bool {
        !title.isEmpty && !content.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Note title", text: $title)
                }

                Section("Content") {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                }
            }
            .navigationTitle("Add Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveNote()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }

    private func saveNote() {
        guard let data = content.data(using: .utf8) else { return }

        let document = Document(
            type: .note,
            title: title,
            fileData: data,
            fileName: "\(title).txt",
            mimeType: "text/plain",
            fileSize: Int64(data.count)
        )

        document.trip = trip
        modelContext.insert(document)

        do {
            try modelContext.save()
            dismiss()
            onComplete()
        } catch {
            print("Error saving note: \(error)")
        }
    }
}
