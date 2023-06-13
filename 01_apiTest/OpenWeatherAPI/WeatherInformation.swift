//
//  WeatherInformation.swift
//  07. 날씨 앱 만들기
//
//  Created by YHChoi on 2022/05/14.
//

import Foundation

struct WeatherInformation: Codable {
    // Codable 프로토콜 채택 : codable은 자신을 변환하거나 외부 표현(json같은)을 변환하는 타입
    // 여기서는 weatherInformation 객체를 json 형태로 만들 수 있고, json 객체를 weatherInformation 객체로 만들 수 있음
    
    // json에서 아래에서 정의한 변수들을 배열키로 가지고 있음
    let weather: [Weather]
    // temp를 json의 "main" 키와 매핑시켜야 함
    let temp: Temp
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case name
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}


struct Temp: Codable { // json key와 이름을 다르게 사용할 시 매핑시켜야 함
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    let humidity: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
        case humidity
    }
}
