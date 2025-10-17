import SwiftUI

struct TripRowView: View {
    let trip: Trip

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(trip.name)
                .font(.headline)

            if let startDate = trip.startDate {
                Text(startDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
