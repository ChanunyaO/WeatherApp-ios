//
//  Weather_AppApp.swift
//  Weather App
//
//  Created by Wha Chanunya on 17/5/2567 BE.
//

import SwiftUI

@main
struct Weather_AppApp: App {
    @StateObject var weatherManager = WeatherManager()
    
    var body: some Scene {
        WindowGroup {
            WeatherMainView()
                .environmentObject(weatherManager)
        }
    }
}
