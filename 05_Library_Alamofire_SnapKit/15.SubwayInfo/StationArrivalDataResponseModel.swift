//
//  StationArrivalDataResponseModel.swift
//  15.SubwayInfo
//
//  Created by yeonhoc5 on 2022/09/06.
//

import Foundation

struct StationArrivalDataResponseModel: Decodable {
    
    var arrivalList: [ArrivalList]
    
    enum CodingKeys: String, CodingKey {
        case arrivalList = "realtimeArrivalList"
    }
}


struct ArrivalList: Decodable {
    
    var trainLineNum: String
    var remainTime: String
    var currentStation: String
    
    enum CodingKeys: String, CodingKey {
        case trainLineNum = "trainLineNm"
        case remainTime = "arvlMsg2"
        case currentStation = "arvlMsg3"
    }
}
