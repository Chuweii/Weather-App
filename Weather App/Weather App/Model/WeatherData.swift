//
//  WeatherData.swift
//  Weather App
//
//  Created by Wei Chu on 2022/9/17.
//

import Foundation

class WeatherData{
    var temperature:Int?
    var condition:Int?
    var city:String?
    var weatherIconName:String?
    
    func updateWeatherIcon(conditionId:Int) -> String{
        switch conditionId {
        case 0...232:
            return "thunderstorm"
            
        case 300...531:
            return "rainy"
            
        case 600...622:
            return "snow"
            
        case 701...781:
            return "smoke"
            
        case 800:
            return "sun"
            
        case 801...804:
            return "cloud"
            
        default:
            return "thunderstorm"
        }
    }
}
