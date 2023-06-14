//
//  Repository.swift
//  23-2.githubRe
//
//  Created by yeonhoc5 on 2023/05/12.
//

import Foundation

struct Repository: Decodable {
    
    let id: Int
    let name: String
    let description: String?
    let stargazersCount: Int
    let language: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, language
        case stargazersCount = "stargazers_count"
    }
    
    
}
