//
//  ResultResponse.swift
//  Slang-App
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import Foundation

struct ResultResponse: Codable {
    let list: [Slang]
}

struct Slang: Codable {
    let defid: Int
    var word: String
    var definition: String
    var author: String
    let thumbsUp: Int
    let thumbsDown: Int
    var example: String
    var permalink: String
    let writtenOn: String
}

extension Slang: SlangRepresentable {
    var _thumbsUp: Int {
        return thumbsUp
    }
    
    var _thumbsDown: Int {
        return thumbsDown
    }
    
    var _writtenOn: Date {
        return Date.getDate(fromString: writtenOn)
    }
}
