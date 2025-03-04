//
//  WeatherManager.swift
//  CycloStats
//
//  Created by Theo Sementa on 22/12/2024.
//

import Foundation
import WeatherKit
import CoreLocation

final class WeatherManager: ObservableObject {
    private let weatherService: WeatherService = .init()
    @Published var weather: Weather?
    @Published var dayWeather: DayWeather?

    @MainActor
    func getWeather(lat: Double, long: Double, date: Date) async {
        do {
            let weatherService = WeatherService()
            let location = CLLocation(latitude: lat, longitude: long)

            let forecast = try await weatherService.weather(
                for: location,
                including: .daily(startDate: date.startOfDay, endDate: date.endOfDay)
            )

            self.dayWeather = forecast.forecast.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
        } catch {
            print("Failed to get weather data: \(error)")
        }
    }
}
