//
//  StationResponseModel.swift
//  15.SubwayInfo
//
//  Created by yeonhoc5 on 2022/09/06.
//

import Foundation


struct StationResponseModel: Decodable {

    var stations: [Station] { searchInfo.row }
    
    private let searchInfo: SearchInfoBySubwayNameServiceModel

    enum CodingKeys: String, CodingKey {
        case searchInfo = "SearchInfoBySubwayNameService"
    }
    
    struct SearchInfoBySubwayNameServiceModel: Decodable {
        var row: [Station] = []
        
    }
}

struct Station: Decodable {
    var stationName: String
    var lineNumber: String
    
    enum CodingKeys: String, CodingKey {
        case stationName = "STATION_NM"
        case lineNumber = "LINE_NUM"
    }
}

