//
//  DocumentRepository.swift
//  TripBro
//
//  Created by TripBro Team
//

import Foundation
import SwiftData

/// Repository for managing Document CRUD operations
@MainActor
class DocumentRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    /// Fetch all documents for a specific trip
    func fetchDocuments(for trip: Trip) throws -> [Document] {
        let predicate = #Predicate<Document> { document in
            document.trip?.id == trip.id
        }
        let descriptor = FetchDescriptor<Document>(predicate: predicate, sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        return try modelContext.fetch(descriptor)
    }

    /// Fetch all documents
    func fetchAllDocuments() throws -> [Document] {
        let descriptor = FetchDescriptor<Document>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        return try modelContext.fetch(descriptor)
    }

    /// Fetch a document by ID
    func fetchDocument(by id: UUID) throws -> Document? {
        let predicate = #Predicate<Document> { document in
            document.id == id
        }
        let descriptor = FetchDescriptor<Document>(predicate: predicate)
        return try modelContext.fetch(descriptor).first
    }

    /// Add a new document
    func addDocument(_ document: Document) {
        modelContext.insert(document)
        save()
    }

    /// Update an existing document
    func updateDocument(_ document: Document) {
        document.updatedAt = Date()
        save()
    }

    /// Delete a document
    func deleteDocument(_ document: Document) {
        modelContext.delete(document)
        save()
    }

    /// Delete multiple documents
    func deleteDocuments(_ documents: [Document]) {
        for document in documents {
            modelContext.delete(document)
        }
        save()
    }

    /// Save changes to the model context
    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving document: \(error.localizedDescription)")
        }
    }
}
