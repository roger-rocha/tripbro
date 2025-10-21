//
//  Document.swift
//  TripBro
//
//  Created by TripBro Team
//

import Foundation
import SwiftData

/// Represents different types of documents that can be stored
enum DocumentType: String, Codable, CaseIterable {
    case pdf = "PDF"
    case image = "Image"
    case note = "Note"
    case other = "Other"

    var icon: String {
        switch self {
        case .pdf: return "doc.fill"
        case .image: return "photo.fill"
        case .note: return "note.text"
        case .other: return "doc"
        }
    }
}

/// Document model for storing files offline using SwiftData
@Model
final class Document {
    var id: UUID
    var type: DocumentType
    var title: String
    var fileData: Data?           // Raw file storage for offline access
    var fileName: String?          // Original file name
    var mimeType: String?
    var fileSize: Int64
    var createdAt: Date
    var updatedAt: Date
    var notes: String?

    @Relationship(deleteRule: .nullify, inverse: \Trip.documents)
    var trip: Trip?

    init(
        id: UUID = UUID(),
        type: DocumentType,
        title: String,
        fileData: Data? = nil,
        fileName: String? = nil,
        mimeType: String? = nil,
        fileSize: Int64 = 0,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        notes: String? = nil
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.fileData = fileData
        self.fileName = fileName
        self.mimeType = mimeType
        self.fileSize = fileSize
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.notes = notes
    }

    /// Formatted file size string
    var formattedFileSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: fileSize)
    }

    /// Check if document has local file data
    var isAvailableOffline: Bool {
        return fileData != nil && fileData!.count > 0
    }
}
