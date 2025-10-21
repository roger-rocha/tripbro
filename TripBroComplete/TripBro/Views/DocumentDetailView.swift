//
//  DocumentDetailView.swift
//  TripBro
//
//  Created by TripBro Team
//

import SwiftUI
import PDFKit

struct DocumentDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let document: Document

    @State private var editingNotes = false
    @State private var notes: String

    init(document: Document) {
        self.document = document
        _notes = State(initialValue: document.notes ?? "")
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Document Preview
                documentPreview
                    .frame(maxWidth: .infinity)
                    .frame(height: 400)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                // Document Info
                VStack(alignment: .leading, spacing: 16) {
                    // Title and Type
                    VStack(alignment: .leading, spacing: 8) {
                        Text(document.title)
                            .font(.title2)
                            .fontWeight(.bold)

                        HStack {
                            Label(document.type.rawValue, systemImage: document.type.icon)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Spacer()

                            if document.isAvailableOffline {
                                Label("Available Offline", systemImage: "arrow.down.circle.fill")
                                    .font(.subheadline)
                                    .foregroundStyle(.green)
                            }
                        }
                    }

                    Divider()

                    // Metadata
                    VStack(alignment: .leading, spacing: 12) {
                        metadataRow(label: "File Size", value: document.formattedFileSize)

                        if let fileName = document.fileName {
                            metadataRow(label: "File Name", value: fileName)
                        }

                        if let mimeType = document.mimeType {
                            metadataRow(label: "Type", value: mimeType)
                        }

                        metadataRow(label: "Created", value: document.createdAt.formatted(date: .abbreviated, time: .shortened))

                        if document.updatedAt != document.createdAt {
                            metadataRow(label: "Updated", value: document.updatedAt.formatted(date: .abbreviated, time: .shortened))
                        }
                    }

                    Divider()

                    // Notes Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Notes")
                                .font(.headline)

                            Spacer()

                            Button(editingNotes ? "Done" : "Edit") {
                                if editingNotes {
                                    saveNotes()
                                }
                                editingNotes.toggle()
                            }
                            .font(.subheadline)
                        }

                        if editingNotes {
                            TextEditor(text: $notes)
                                .frame(minHeight: 100)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            Text(notes.isEmpty ? "No notes" : notes)
                                .font(.body)
                                .foregroundStyle(notes.isEmpty ? .secondary : .primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("Document Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }

    @ViewBuilder
    private var documentPreview: some View {
        switch document.type {
        case .image:
            imagePreview
        case .pdf:
            pdfPreview
        case .note:
            notePreview
        case .other:
            genericPreview
        }
    }

    @ViewBuilder
    private var imagePreview: some View {
        if let data = document.fileData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            placeholderView(icon: "photo", text: "Image not available")
        }
    }

    @ViewBuilder
    private var pdfPreview: some View {
        if let data = document.fileData {
            PDFPreviewView(data: data)
        } else {
            placeholderView(icon: "doc.fill", text: "PDF not available")
        }
    }

    @ViewBuilder
    private var notePreview: some View {
        if let data = document.fileData, let text = String(data: data, encoding: .utf8) {
            ScrollView {
                Text(text)
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        } else {
            placeholderView(icon: "note.text", text: "Note not available")
        }
    }

    @ViewBuilder
    private var genericPreview: some View {
        placeholderView(icon: "doc", text: "Preview not available")
    }

    private func placeholderView(icon: String, text: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text(text)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func metadataRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 100, alignment: .leading)

            Text(value)
                .font(.subheadline)

            Spacer()
        }
    }

    private func saveNotes() {
        document.notes = notes.isEmpty ? nil : notes
        document.updatedAt = Date()
        try? modelContext.save()
    }
}

// MARK: - PDF Preview View

struct PDFPreviewView: View {
    let data: Data

    var body: some View {
        if let pdfDocument = PDFDocument(data: data) {
            PDFKitView(document: pdfDocument)
        } else {
            VStack(spacing: 16) {
                Image(systemName: "doc.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.secondary)

                Text("Unable to load PDF")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - PDFKit View Wrapper

struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = document
    }
}
