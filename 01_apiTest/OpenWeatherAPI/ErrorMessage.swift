//
//  ErrorMessage.swift
//  07. 날씨 앱 만들기
//
//  Created by YHChoi on 2022/05/14.
//

import Foundation

// 서버에서 받은 에러메세지를 alert으로 표현하도록 -> error 메세지 json data를 매핑하는 구조체
struct ErrorMessage: Codable {
    let message: String
}
