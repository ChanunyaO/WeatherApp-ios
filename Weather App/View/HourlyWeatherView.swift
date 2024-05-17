//
//  HourlyWeatherView.swift
//  Weather App
//
//  Created by Wha Chanunya on 17/5/2567 BE.
//

import SwiftUI

struct HourlyWeatherView: View {
    @Binding var dailyWeather: DailyWeather
    @EnvironmentObject var weatherManager: WeatherManager
    
    var body: some View {
        ScrollView {
            if weatherManager.hourlyTemperatureList.count > 0{
                ForEach(0..<weatherManager.hourlyTemperatureList.count, id: \.self) { i in
                    if weatherManager.hourlyTemperatureList[i].date == dailyWeather.date {
                        HStack {
                            Text("\(weatherManager.hourlyTemperatureList[i].time)")
                            Spacer()
                            Text("\(String(format: "%.1f", weatherManager.hourlyTemperatureList[i].temperature))°")
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 50)
                        .foregroundStyle(.white)
                    }
                }
            }
        }
        .background(Color("carolina"))
        .navigationTitle("\(dailyWeather.dayOfWeek), \(dailyWeather.monthDate)")
    }
}
