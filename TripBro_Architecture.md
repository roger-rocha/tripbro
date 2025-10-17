# TripBro - Technical Architecture Document

## Overview

This document outlines the technical architecture for TripBro, a modern iOS travel planning application built with SwiftUI and SwiftData. The architecture emphasizes modularity, testability, and adherence to iOS best practices.

## Technology Stack

### Core Technologies
- **Language:** Swift 5.9+
- **UI Framework:** SwiftUI
- **Data Persistence:** SwiftData
- **Cloud Sync:** CloudKit
- **Minimum iOS Version:** iOS 17.0
- **Platforms:** iPhone, iPad, Mac (Catalyst), Apple Watch

### Key Frameworks
- **MapKit:** Interactive maps and location services
- **WeatherKit:** Weather forecasts and conditions
- **EventKit:** Calendar integration
- **PDFKit:** Document viewing
- **Vision:** Document scanning and OCR
- **UserNotifications:** Push notifications
- **WidgetKit:** Home screen widgets
- **ActivityKit:** Live Activities

## Architecture Pattern

### MVVM-C (Model-View-ViewModel-Coordinator)

```
┌─────────────┐
│    View     │ (SwiftUI Views)
├─────────────┤
│  ViewModel  │ (ObservableObject)
├─────────────┤
│   Service   │ (Business Logic)
├─────────────┤
│ Repository  │ (Data Access)
├─────────────┤
│    Model    │ (SwiftData)
└─────────────┘
```

### Layer Responsibilities

#### Presentation Layer (Views)
- SwiftUI views for user interface
- Declarative UI with data binding
- Navigation and routing
- User input handling

#### ViewModel Layer
- Business logic coordination
- Data transformation for views
- State management
- User action handling

#### Service Layer
- API integration
- Business rules
- Data validation
- External service communication

#### Repository Layer
- Data access abstraction
- CRUD operations
- Caching strategies
- Data source management

#### Data Layer
- SwiftData models
- CloudKit integration
- Local storage
- Data migration

## Project Structure

```
TripBro/
├── App/
│   ├── TripBroApp.swift
│   ├── AppDelegate.swift
│   ├── Info.plist
│   └── Assets.xcassets
├── Core/
│   ├── Models/
│   │   ├── Trip.swift
│   │   ├── Activity.swift
│   │   ├── Expense.swift
│   │   ├── Document.swift
│   │   └── User.swift
│   ├── Database/
│   │   ├── ModelContainer+Extensions.swift
│   │   ├── DatabaseManager.swift
│   │   └── Migrations/
│   ├── Services/
│   │   ├── FlightService.swift
│   │   ├── WeatherService.swift
│   │   ├── NotificationService.swift
│   │   ├── EmailService.swift
│   │   ├── SyncService.swift
│   │   └── LocationService.swift
│   ├── Repositories/
│   │   ├── TripRepository.swift
│   │   ├── ActivityRepository.swift
│   │   ├── ExpenseRepository.swift
│   │   └── DocumentRepository.swift
│   ├── Network/
│   │   ├── APIClient.swift
│   │   ├── Endpoints.swift
│   │   └── NetworkManager.swift
│   └── Utilities/
│       ├── Extensions/
│       ├── Helpers/
│       └── Constants.swift
├── Features/
│   ├── Trips/
│   │   ├── Views/
│   │   │   ├── TripListView.swift
│   │   │   ├── TripDetailView.swift
│   │   │   └── AddTripView.swift
│   │   ├── ViewModels/
│   │   │   ├── TripListViewModel.swift
│   │   │   └── TripDetailViewModel.swift
│   │   └── Components/
│   │       ├── TripCard.swift
│   │       └── TripRow.swift
│   ├── Itinerary/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── Components/
│   ├── Expenses/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── Components/
│   ├── Documents/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── Components/
│   └── Settings/
│       ├── Views/
│       ├── ViewModels/
│       └── Components/
├── Shared/
│   ├── Views/
│   │   ├── LoadingView.swift
│   │   ├── ErrorView.swift
│   │   └── EmptyStateView.swift
│   ├── Components/
│   │   ├── CustomButton.swift
│   │   ├── SearchBar.swift
│   │   └── ImagePicker.swift
│   └── Modifiers/
│       ├── CardStyle.swift
│       └── NavigationStyle.swift
├── Resources/
│   ├── Localizable.strings
│   ├── Colors.xcassets
│   └── Images.xcassets
└── Tests/
    ├── UnitTests/
    ├── IntegrationTests/
    └── UITests/
```

## Data Models (SwiftData)

### Core Models

```swift
import SwiftData
import Foundation

// MARK: - Trip Model
@Model
final class Trip {
    @Attribute(.unique) var id: UUID
    var name: String
    var startDate: Date?
    var endDate: Date?
    var coverImageData: Data?
    var tripType: TripType
    var isArchived: Bool
    var createdAt: Date
    var updatedAt: Date
    var countryFlags: [String]

    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \Activity.trip)
    var activities: [Activity]?

    @Relationship(deleteRule: .cascade, inverse: \Expense.trip)
    var expenses: [Expense]?

    @Relationship(deleteRule: .cascade, inverse: \Document.trip)
    var documents: [Document]?

    @Relationship(inverse: \User.trips)
    var collaborators: [User]?

    init(name: String, tripType: TripType = .leisure) {
        self.id = UUID()
        self.name = name
        self.tripType = tripType
        self.isArchived = false
        self.createdAt = Date()
        self.updatedAt = Date()
        self.countryFlags = []
    }
}

// MARK: - Activity Model
@Model
final class Activity {
    @Attribute(.unique) var id: UUID
    var type: ActivityType
    var title: String
    var startDateTime: Date
    var endDateTime: Date?
    var locationName: String?
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var notes: String?
    var confirmationNumber: String?
    var bookingURL: String?
    var createdAt: Date
    var updatedAt: Date

    // Flight specific
    var flightNumber: String?
    var airline: String?
    var departureAirport: String?
    var arrivalAirport: String?
    var terminal: String?
    var gate: String?
    var seatNumber: String?

    // Accommodation specific
    var checkInTime: Date?
    var checkOutTime: Date?
    var roomNumber: String?

    // Relationships
    @Relationship(inverse: \Trip.activities)
    var trip: Trip?

    init(type: ActivityType, title: String, startDateTime: Date) {
        self.id = UUID()
        self.type = type
        self.title = title
        self.startDateTime = startDateTime
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Expense Model
@Model
final class Expense {
    @Attribute(.unique) var id: UUID
    var amount: Decimal
    var currency: String
    var category: ExpenseCategory
    var title: String
    var notes: String?
    var date: Date
    var paymentMethod: PaymentMethod?
    var receiptImageData: Data?
    var isShared: Bool
    var splitBetween: [String]? // User IDs
    var createdAt: Date
    var updatedAt: Date

    // Relationships
    @Relationship(inverse: \Trip.expenses)
    var trip: Trip?

    init(amount: Decimal, currency: String, category: ExpenseCategory, title: String, date: Date) {
        self.id = UUID()
        self.amount = amount
        self.currency = currency
        self.category = category
        self.title = title
        self.date = date
        self.isShared = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Document Model
@Model
final class Document {
    @Attribute(.unique) var id: UUID
    var type: DocumentType
    var title: String
    var fileData: Data?
    var url: String?
    var mimeType: String?
    var fileSize: Int64
    var createdAt: Date
    var updatedAt: Date
    var isShared: Bool

    // Relationships
    @Relationship(inverse: \Trip.documents)
    var trip: Trip?

    init(type: DocumentType, title: String) {
        self.id = UUID()
        self.type = type
        self.title = title
        self.fileSize = 0
        self.isShared = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - User Model
@Model
final class User {
    @Attribute(.unique) var id: UUID
    var email: String
    var name: String
    var profileImageData: Data?
    var role: UserRole
    var createdAt: Date
    var updatedAt: Date

    // Relationships
    @Relationship(inverse: \Trip.collaborators)
    var trips: [Trip]?

    init(email: String, name: String, role: UserRole = .viewer) {
        self.id = UUID()
        self.email = email
        self.name = name
        self.role = role
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Enumerations
enum TripType: String, Codable, CaseIterable {
    case leisure = "Leisure"
    case business = "Business"
    case adventure = "Adventure"
    case family = "Family"
    case romantic = "Romantic"
    case solo = "Solo"
    case group = "Group"
}

enum ActivityType: String, Codable, CaseIterable {
    case flight = "Flight"
    case accommodation = "Accommodation"
    case carRental = "Car Rental"
    case train = "Train"
    case bus = "Bus"
    case restaurant = "Restaurant"
    case activity = "Activity"
    case tour = "Tour"
    case custom = "Custom"
}

enum ExpenseCategory: String, Codable, CaseIterable {
    case flight = "Flight"
    case accommodation = "Accommodation"
    case transportation = "Transportation"
    case food = "Food & Dining"
    case activities = "Activities"
    case shopping = "Shopping"
    case other = "Other"
}

enum PaymentMethod: String, Codable, CaseIterable {
    case cash = "Cash"
    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case paypal = "PayPal"
    case other = "Other"
}

enum DocumentType: String, Codable, CaseIterable {
    case pdf = "PDF"
    case image = "Image"
    case note = "Note"
    case link = "Link"
    case email = "Email"
}

enum UserRole: String, Codable {
    case owner = "Owner"
    case collaborator = "Collaborator"
    case viewer = "Viewer"
}
```

## Service Layer Architecture

### Service Protocol Pattern

```swift
// MARK: - Service Protocol
protocol TripServiceProtocol {
    func fetchTrips() async throws -> [Trip]
    func createTrip(_ trip: Trip) async throws
    func updateTrip(_ trip: Trip) async throws
    func deleteTrip(_ trip: Trip) async throws
    func shareTrip(_ trip: Trip, with email: String) async throws
}

// MARK: - Service Implementation
@MainActor
final class TripService: TripServiceProtocol {
    private let repository: TripRepositoryProtocol
    private let syncService: SyncServiceProtocol
    private let notificationService: NotificationServiceProtocol

    init(repository: TripRepositoryProtocol,
         syncService: SyncServiceProtocol,
         notificationService: NotificationServiceProtocol) {
        self.repository = repository
        self.syncService = syncService
        self.notificationService = notificationService
    }

    func fetchTrips() async throws -> [Trip] {
        let trips = try await repository.fetchAll()
        await syncService.syncTrips(trips)
        return trips
    }

    func createTrip(_ trip: Trip) async throws {
        try await repository.create(trip)
        await syncService.uploadTrip(trip)
        await notificationService.scheduleReminderFor(trip)
    }

    // Additional implementations...
}
```

## Repository Pattern

```swift
// MARK: - Repository Protocol
protocol RepositoryProtocol {
    associatedtype Entity
    func fetchAll() async throws -> [Entity]
    func fetch(by id: UUID) async throws -> Entity?
    func create(_ entity: Entity) async throws
    func update(_ entity: Entity) async throws
    func delete(_ entity: Entity) async throws
}

// MARK: - Trip Repository
final class TripRepository: RepositoryProtocol {
    typealias Entity = Trip

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() async throws -> [Trip] {
        let descriptor = FetchDescriptor<Trip>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func fetch(by id: UUID) async throws -> Trip? {
        let descriptor = FetchDescriptor<Trip>(
            predicate: #Predicate { $0.id == id }
        )
        return try modelContext.fetch(descriptor).first
    }

    func create(_ entity: Trip) async throws {
        modelContext.insert(entity)
        try modelContext.save()
    }

    // Additional implementations...
}
```

## ViewModel Pattern

```swift
// MARK: - Base ViewModel
@MainActor
class BaseViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false

    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}

// MARK: - Trip List ViewModel
@MainActor
final class TripListViewModel: BaseViewModel {
    @Published var trips: [Trip] = []
    @Published var searchText = ""
    @Published var selectedFilter: TripFilter = .all

    private let tripService: TripServiceProtocol

    var filteredTrips: [Trip] {
        trips
            .filter { trip in
                searchText.isEmpty || trip.name.localizedCaseInsensitiveContains(searchText)
            }
            .filter { trip in
                switch selectedFilter {
                case .all:
                    return true
                case .upcoming:
                    return trip.startDate ?? Date() > Date()
                case .past:
                    return trip.endDate ?? Date() < Date()
                case .current:
                    let now = Date()
                    return (trip.startDate ?? now) <= now && (trip.endDate ?? now) >= now
                }
            }
    }

    init(tripService: TripServiceProtocol) {
        self.tripService = tripService
        super.init()
    }

    func loadTrips() async {
        isLoading = true
        do {
            trips = try await tripService.fetchTrips()
        } catch {
            handleError(error)
        }
        isLoading = false
    }

    func deleteTrip(at offsets: IndexSet) async {
        for index in offsets {
            let trip = filteredTrips[index]
            do {
                try await tripService.deleteTrip(trip)
                trips.removeAll { $0.id == trip.id }
            } catch {
                handleError(error)
            }
        }
    }
}

enum TripFilter: String, CaseIterable {
    case all = "All"
    case upcoming = "Upcoming"
    case current = "Current"
    case past = "Past"
}
```

## Navigation Architecture

```swift
// MARK: - Navigation Coordinator
@MainActor
final class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedTab: Tab = .trips
    @Published var showingAddTrip = false
    @Published var selectedTrip: Trip?

    enum Tab: String, CaseIterable {
        case trips = "Trips"
        case discover = "Discover"
        case stats = "Stats"
        case settings = "Settings"

        var icon: String {
            switch self {
            case .trips: return "suitcase"
            case .discover: return "magnifyingglass"
            case .stats: return "chart.bar"
            case .settings: return "gearshape"
            }
        }
    }

    func navigateToTrip(_ trip: Trip) {
        selectedTrip = trip
        path.append(trip)
    }

    func navigateToActivity(_ activity: Activity) {
        path.append(activity)
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
```

## Dependency Injection

```swift
// MARK: - Dependency Container
@MainActor
final class DependencyContainer: ObservableObject {
    let modelContainer: ModelContainer
    let tripService: TripServiceProtocol
    let activityService: ActivityServiceProtocol
    let expenseService: ExpenseServiceProtocol
    let documentService: DocumentServiceProtocol
    let syncService: SyncServiceProtocol
    let notificationService: NotificationServiceProtocol

    init() throws {
        // Initialize ModelContainer
        self.modelContainer = try ModelContainer(
            for: Trip.self, Activity.self, Expense.self, Document.self, User.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )

        // Initialize Services
        let modelContext = modelContainer.mainContext

        let tripRepository = TripRepository(modelContext: modelContext)
        let activityRepository = ActivityRepository(modelContext: modelContext)
        let expenseRepository = ExpenseRepository(modelContext: modelContext)
        let documentRepository = DocumentRepository(modelContext: modelContext)

        self.syncService = CloudKitSyncService()
        self.notificationService = NotificationService()

        self.tripService = TripService(
            repository: tripRepository,
            syncService: syncService,
            notificationService: notificationService
        )

        self.activityService = ActivityService(repository: activityRepository)
        self.expenseService = ExpenseService(repository: expenseRepository)
        self.documentService = DocumentService(repository: documentRepository)
    }
}

// MARK: - Environment Injection
struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue = try! DependencyContainer()
}

extension EnvironmentValues {
    var dependencies: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}
```

## CloudKit Integration

```swift
// MARK: - CloudKit Sync Service
final class CloudKitSyncService: SyncServiceProtocol {
    private let container = CKContainer(identifier: "iCloud.com.tripbro.app")
    private let privateDatabase: CKDatabase
    private let sharedDatabase: CKDatabase

    init() {
        self.privateDatabase = container.privateCloudDatabase
        self.sharedDatabase = container.sharedCloudDatabase
    }

    func syncTrips(_ trips: [Trip]) async {
        for trip in trips {
            await uploadTrip(trip)
        }
    }

    func uploadTrip(_ trip: Trip) async {
        let record = tripToRecord(trip)
        do {
            try await privateDatabase.save(record)
        } catch {
            print("Failed to upload trip: \(error)")
        }
    }

    private func tripToRecord(_ trip: Trip) -> CKRecord {
        let record = CKRecord(recordType: "Trip")
        record["id"] = trip.id.uuidString
        record["name"] = trip.name
        record["startDate"] = trip.startDate
        record["endDate"] = trip.endDate
        record["tripType"] = trip.tripType.rawValue
        record["isArchived"] = trip.isArchived

        if let imageData = trip.coverImageData {
            let url = FileManager.default.temporaryDirectory.appendingPathComponent(trip.id.uuidString)
            try? imageData.write(to: url)
            record["coverImage"] = CKAsset(fileURL: url)
        }

        return record
    }

    func shareTrip(_ trip: Trip, with participants: [String]) async throws {
        let share = CKShare(rootRecord: tripToRecord(trip))
        share[CKShare.SystemFieldKey.title] = trip.name
        share[CKShare.SystemFieldKey.shareType] = "com.tripbro.trip"

        for email in participants {
            let participant = CKShare.Participant()
            participant.permission = .readWrite
            share.addParticipant(participant)
        }

        try await sharedDatabase.save(share)
    }
}
```

## Security & Privacy

### Data Encryption
- Sensitive data encrypted with AES-256
- Keychain storage for API keys
- Biometric authentication for app access

### Privacy Considerations
- Location data only when necessary
- Photo library access on demand
- CloudKit private database for personal data

## Performance Optimization

### Strategies
- Lazy loading for lists
- Image compression and caching
- Background queue for heavy operations
- Prefetching for predictable navigation
- SwiftData batch operations

### Monitoring
- Instruments profiling
- Memory leak detection
- Network activity monitoring
- Battery usage optimization

## Testing Strategy

### Unit Tests
- Model validation
- Service logic
- ViewModel state management
- Utility functions

### Integration Tests
- Repository operations
- Service interactions
- CloudKit sync
- API integration

### UI Tests
- User flows
- Accessibility
- Device rotation
- Dark mode support

## Deployment Configuration

### Build Configurations
- Debug: Local development
- Staging: TestFlight beta
- Release: App Store distribution

### Environment Variables
- API endpoints
- Feature flags
- Analytics keys
- CloudKit container

## Conclusion

This architecture provides a solid foundation for building TripBro with modern iOS technologies. The modular structure ensures maintainability, testability, and scalability as the application grows.