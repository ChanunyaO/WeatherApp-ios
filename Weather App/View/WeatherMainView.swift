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
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    Color("carolina")
                        .ignoresSafeArea()
                    VStack {
                        if weatherManager.dailyWeatherList.count > 0 {
                            NavigationLink(destination: {
                                HourlyWeatherView(dailyWeather: $weatherManager.dailyWeatherList[0])
                            }, label: {
                                Text("\(String(format: "%.1f", weatherManager.dailyWeatherList[0].minTemperature))°/\(String(format: "%.1f", weatherManager.dailyWeatherList[0].maxTemperature))°")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundStyle(.white)
                            })
                            .padding(.top, 20)
                            VStack (alignment: .leading) {
                                ForEach(0..<weatherManager.dailyWeatherList.count, id: \.self) { i in
                                    NavigationLink(destination: {
                                        HourlyWeatherView(dailyWeather: $weatherManager.dailyWeatherList[i])
                                    }, label: {
                                        HStack {
                                            Text(weatherManager.dailyWeatherList[i].dateMonth)
                                                .padding(.leading, 10)
                                                .padding(.trailing, 15)
                                            Text(weatherManager.dailyWeatherList[i].dayOfWeek)
                                            Spacer()
                                            Text("\(String(format: "%.1f", weatherManager.dailyWeatherList[i].minTemperature))°/\(String(format: "%.1f", weatherManager.dailyWeatherList[i].maxTemperature))°")
                                                .padding(.trailing, 15)
                                        }
                                        .foregroundStyle(.white)
                                    })
                                    .padding(8)
                                }
                            }
                            .frame(width: geo.size.width)
                            Spacer()
                        }
                    }
                }
            } // NavigationView
        }
        .onAppear {
            print("hi")
            weatherManager.getMaxMinTemperature()
            weatherManager.getHourlyTemp()
        } // onAppear
        
    }
}
