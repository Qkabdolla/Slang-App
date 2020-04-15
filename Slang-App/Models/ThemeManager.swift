//
//  ThemeManager.swift
//  Slang-App
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import UIKit

class ThemeManager {
    private let userDefaultsKey: String = "appCurrentTheme"
    private var themeApplicables: [ThemeApplicable] = []
    
    var currentTheme: Theme {
        didSet {
            if oldValue != currentTheme {
                UserDefaults.standard.set(currentTheme.rawValue, forKey: userDefaultsKey)
                notifySubscribers()
            }
        }
    }
    
    init() {
        if let theme = UserDefaults.standard.string(forKey: userDefaultsKey) {
            currentTheme = Theme(rawValue: theme)!
        } else {
            currentTheme = .day
            UserDefaults.standard.set(currentTheme.rawValue, forKey: userDefaultsKey)
        }
        
        notifySubscribersThroughNotificationCenter()
    }
    
    func subscribe(_ subscriber: UIView) {
        if let applicableView = subscriber as? ThemeApplicable {
            applicableView.apply(currentTheme)
            themeApplicables.append(applicableView)
        }
        
        subscriber.subviews.forEach {
            subscribe($0)
        }
    }
    
    private func notifySubscribers() {
        notifySubscribersThroughNotificationCenter()
        themeApplicables.forEach {
            $0.apply(currentTheme)
        }
    }
    
    private func notifySubscribersThroughNotificationCenter() {
        NotificationCenter.default.post(name: .didChangeTheme, object: currentTheme)
    }
}
