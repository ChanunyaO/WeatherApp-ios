//
//  WeatherMainView.swift
//  Weather App
//
//  Created by Wha Chanunya on 17/5/2567 BE.
//

import SwiftUI

struct WeatherMainView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    @State private var dailyTemperature: [String: Any] = [:]
    
    var body: some View {
        NavigationView {
            VStack {
                if weatherManager.dailyWeatherList.count > 0 {
                    Text("\(String(format: "%.1f", weatherManager.dailyWeatherList[0].minTemperature))°/\(String(format: "%.1f", weatherManager.dailyWeatherList[0].maxTemperature))°")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                        .foregroundStyle(.white)
                    VStack (alignment: .leading) {
                        ForEach(0..<weatherManager.dailyWeatherList.count, id: \.self) { i in
                            NavigationLink(destination: {
                                HourlyWeatherView(dailyWeather: $weatherManager.dailyWeatherList[i])
                            }, label: {
                                HStack {
                                    Text(weatherManager.dailyWeatherList[i].dateMonth)
                                    Text(weatherManager.dailyWeatherList[i].dayOfWeek)
                                    Text("\(String(format: "%.1f", weatherManager.dailyWeatherList[i].minTemperature))°/\(String(format: "%.1f", weatherManager.dailyWeatherList[i].maxTemperature))°")
                                }
                                .foregroundStyle(.white)
                            })
                        }
                    }
                    .padding(.horizontal, 15)
                    Spacer()
                }
            }
        } // NavigationView
        .background(Color.blue)
        .onAppear {
            weatherManager.getMaxMinTemperature()
            weatherManager.getHourlyTemp()
        } // onAppear
        
    }
}
