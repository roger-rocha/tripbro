//
//  DocumentService.swift
//  TripBro
//
//  Created by TripBro Team
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

/// Service for handling document business logic and file operations
@MainActor
class DocumentService {
    private let repository: DocumentRepository
    private let fileManager = FileManager.default

    // Maximum file size: 50MB
    private let maxFileSize: Int64 = 50 * 1024 * 1024

    // Maximum image dimension for compression
    private let maxImageDimension: CGFloat = 2048

    init(repository: DocumentRepository) {
        self.repository = repository
    }

    /// Create a document from a file URL
    func createDocument(
        from url: URL,
        title: String,
        trip: Trip?,
        notes: String? = nil
    ) throws -> Document {
        // Check if file exists
        guard fileManager.fileExists(atPath: url.path) else {
            throw DocumentError.fileNotFound
        }

        // Read file data
        guard let fileData = try? Data(contentsOf: url) else {
            throw DocumentError.cannotReadFile
        }

        // Check file size
        let fileSize = Int64(fileData.count)
        guard fileSize <= maxFileSize else {
            throw DocumentError.fileTooLarge(size: fileSize, maxSize: maxFileSize)
        }

        // Determine document type and MIME type
        let (documentType, mimeType) = determineFileType(from: url)

        // Compress image if needed
        var processedData = fileData
        if documentType == .image, let compressedData = compressImage(data: fileData) {
            processedData = compressedData
        }

        // Create document
        let document = Document(
            type: documentType,
            title: title,
            fileData: processedData,
            fileName: url.lastPathComponent,
            mimeType: mimeType,
            fileSize: Int64(processedData.count),
            notes: notes
        )

        document.trip = trip

        // Save document
        repository.addDocument(document)

        return document
    }

    /// Update document notes
    func updateDocumentNotes(_ document: Document, notes: String) {
        document.notes = notes
        repository.updateDocument(document)
    }

    /// Delete a document
    func deleteDocument(_ document: Document) {
        repository.deleteDocument(document)
    }

    /// Fetch documents for a trip
    func fetchDocuments(for trip: Trip) throws -> [Document] {
        return try repository.fetchDocuments(for: trip)
    }

    /// Get documents grouped by type
    func getDocumentsGroupedByType(for trip: Trip) throws -> [DocumentType: [Document]] {
        let documents = try repository.fetchDocuments(for: trip)
        return Dictionary(grouping: documents, by: { $0.type })
    }

    // MARK: - Private Methods

    /// Determine file type and MIME type from URL
    private func determineFileType(from url: URL) -> (DocumentType, String?) {
        let pathExtension = url.pathExtension.lowercased()

        // Check for PDF
        if pathExtension == "pdf" {
            return (.pdf, "application/pdf")
        }

        // Check for images
        let imageExtensions = ["jpg", "jpeg", "png", "heic", "heif", "gif", "bmp", "tiff"]
        if imageExtensions.contains(pathExtension) {
            let mimeType: String
            switch pathExtension {
            case "jpg", "jpeg": mimeType = "image/jpeg"
            case "png": mimeType = "image/png"
            case "heic": mimeType = "image/heic"
            case "heif": mimeType = "image/heif"
            case "gif": mimeType = "image/gif"
            case "bmp": mimeType = "image/bmp"
            case "tiff": mimeType = "image/tiff"
            default: mimeType = "image/\(pathExtension)"
            }
            return (.image, mimeType)
        }

        // Check for text/notes
        let textExtensions = ["txt", "md", "rtf"]
        if textExtensions.contains(pathExtension) {
            return (.note, "text/plain")
        }

        // Default to other
        return (.other, nil)
    }

    /// Compress image data if needed
    private func compressImage(data: Data) -> Data? {
        #if os(iOS)
        guard let image = UIImage(data: data) else { return nil }

        // Calculate new size
        let size = image.size
        var newSize = size

        if size.width > maxImageDimension || size.height > maxImageDimension {
            let ratio = size.width / size.height
            if size.width > size.height {
                newSize = CGSize(width: maxImageDimension, height: maxImageDimension / ratio)
            } else {
                newSize = CGSize(width: maxImageDimension * ratio, height: maxImageDimension)
            }
        }

        // Resize if needed
        let resizedImage: UIImage
        if newSize != size {
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
            UIGraphicsEndImageContext()
        } else {
            resizedImage = image
        }

        // Compress to JPEG with quality 0.8
        return resizedImage.jpegData(compressionQuality: 0.8)
        #else
        return data
        #endif
    }
}

// MARK: - Document Errors

enum DocumentError: LocalizedError {
    case fileNotFound
    case cannotReadFile
    case fileTooLarge(size: Int64, maxSize: Int64)
    case unsupportedFileType

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "File not found"
        case .cannotReadFile:
            return "Cannot read file"
        case .fileTooLarge(let size, let maxSize):
            let formatter = ByteCountFormatter()
            let sizeStr = formatter.string(fromByteCount: size)
            let maxSizeStr = formatter.string(fromByteCount: maxSize)
            return "File size (\(sizeStr)) exceeds maximum allowed size (\(maxSizeStr))"
        case .unsupportedFileType:
            return "Unsupported file type"
        }
    }
}
