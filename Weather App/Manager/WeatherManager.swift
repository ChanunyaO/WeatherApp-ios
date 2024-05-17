//
//  WeatherManager.swift
//  Weather App
//
//  Created by Wha Chanunya on 17/5/2567 BE.
//

import Foundation

struct DailyWeather {
    var date: String
    let dateMonth: String
    let monthDate: String
    let dayOfWeek: String
    let maxTemperature: Double
    let minTemperature: Double
}

struct Hourly {
    let date: String
    let timeTemp: TimeTemp
    
    struct TimeTemp {
        let time: String
        let temperature: Double
    }
}

class WeatherManager: NSObject, ObservableObject {
    @Published var dailyWeatherList: [DailyWeather] = []
    @Published var hourlyTemperatureList: [Hourly] = []
    
    func getMaxMinTemperature() {
        Task {
            let url = URL(string: "https://api.open-meteo.com/v1/forecast?daily=temperature_2m_max,temperature_2m_min&latitude=15.87&longitude=100.9925&timezone=Asia%2FBangkok")!
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                            print("error in JSONSerialization")
                            return
                        }
                        
                        if jsonResponse["daily"] != nil {
                            let dailyTemperature = jsonResponse["daily"] as! [String: Any]
                            let dates = dailyTemperature["time"] as! [String]
                            let dailyTemperatureMin = dailyTemperature["temperature_2m_min"] as! [Double]
                            let dailyTemperatureMax = dailyTemperature["temperature_2m_max"] as! [Double]
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            
                            let calendar = Calendar.current
                            
                            for i in 0..<dates.count {
                                if let dateFormatting = dateFormatter.date(from: dates[i]) {
                                    let outputFormatter = DateFormatter()
                                    
                                    outputFormatter.dateFormat = "EEEE"
                                    let dayOfWeek = outputFormatter.string(from: dateFormatting)
                                    
                                    outputFormatter.dateFormat = "d/M"
                                    let dateMonth = outputFormatter.string(from: dateFormatting)
                                    
                                    outputFormatter.dateFormat = "MMMM d"
                                    let monthDate = outputFormatter.string(from: dateFormatting)
                                    
                                    let dailyWeather = DailyWeather(date: dates[i], dateMonth: dateMonth, monthDate: monthDate, dayOfWeek: dayOfWeek, maxTemperature: dailyTemperatureMax[i], minTemperature: dailyTemperatureMin[i])
                                    self.dailyWeatherList.append(dailyWeather)
                                } else {
                                    print("Invalid date format")
                                }
                            }
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func getHourlyTemp() {
        Task {
            let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=15.87&longitude=100.9925&hourly=temperature_2m&timezone=Asia%2FBangkok")!
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                            print("error in JSONSerialization")
                            return
                        }
                        
                        if jsonResponse["hourly"] != nil {
                            let hourly = jsonResponse["hourly"] as! [String: Any]
                            let time = hourly["time"] as! [String]
                            let temp = hourly["temperature_2m"] as! [Double]
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
                            
                            for i in 0..<time.count {
                                if let dateFormatting = dateFormatter.date(from: time[i]) {
                                    let outputFormatter = DateFormatter()
                                    
                                    outputFormatter.dateFormat = "h a"
                                    outputFormatter.amSymbol = "am"
                                        outputFormatter.pmSymbol = "pm"
                                    let time = outputFormatter.string(from: dateFormatting)
                                    
                                    outputFormatter.dateFormat = "yyyy-MM-dd'"
                                    let date = outputFormatter.string(from: dateFormatting)
                                    
                                    let hourTemp = Hourly(date: date, timeTemp: Hourly.TimeTemp(time: time, temperature: temp[i]))
                                    self.hourlyTemperatureList.append(hourTemp)
                                } else {
                                    print("Invalid date format")
                                }
                            }
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
}
