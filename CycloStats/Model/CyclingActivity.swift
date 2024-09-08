import Foundation
import HealthKit

class CyclingActivity: Identifiable, ObservableObject, Hashable {
    @Published var originalWorkout: HKWorkout?
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var durationInMin: Int
    @Published var distanceInKm: Double
    @Published var averageSpeedInKMH: Double
    @Published var maxSpeedInKMH: Double
    @Published var elevationAscendedInM: Double
    @Published var averageHeartRate: Int
    @Published var maxHeartRate: Int
    
    init(originalWorkout: HKWorkout? = nil, startDate: Date, endDate: Date, durationInMin: Int, distanceInKm: Double, averageSpeedInKMH: Double, maxSpeedInKMH: Double, elevationAscendedInM: Double, averageHeartRate: Int, maxHeartRate: Int) {
        self.originalWorkout = originalWorkout
        self.startDate = startDate
        self.endDate = endDate
        self.durationInMin = durationInMin
        self.distanceInKm = distanceInKm
        self.averageSpeedInKMH = averageSpeedInKMH
        self.maxSpeedInKMH = maxSpeedInKMH
        self.elevationAscendedInM = elevationAscendedInM
        self.averageHeartRate = averageHeartRate
        self.maxHeartRate = maxHeartRate
    }
    
    var id: String {
        return "\(distanceInKm)\(elevationAscendedInM)\(averageHeartRate)"
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Equatable
    static func == (lhs: CyclingActivity, rhs: CyclingActivity) -> Bool {
        return lhs.id == rhs.id
    }
}

extension CyclingActivity {
    var date: Date {
        return endDate
    }
}

extension CyclingActivity {
    static var preview: CyclingActivity {
        return .init(
            startDate: .now,
            endDate: .now,
            durationInMin: 34,
            distanceInKm: 12,
            averageSpeedInKMH: 21.4,
            maxSpeedInKMH: 18.1,
            elevationAscendedInM: 75.6,
            averageHeartRate: 125,
            maxHeartRate: 165
        )
    }
}
