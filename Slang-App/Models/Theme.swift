//
//  Theme.swift
//  Slang-App
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

enum Theme: String {
    case night = "night"
    case day = "day"
    
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .night: return .lightContent
        case .day: return .default
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .night: return .black
        case .day: return .white
        }
    }
}
